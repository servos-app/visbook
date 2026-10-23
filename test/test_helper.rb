require "minitest/autorun"
require_relative "../lib/visbook"

class FakeConnection
  attr_reader :requests, :timeouts

  def initialize
    @requests = []
    @timeouts = []
    @responses = []
  end

  def respond_with(status: 200, body: "{}", headers: {})
    @responses << Visbook::Response.new(status: status, body: body, headers: headers)
    self
  end

  def raise_error(error)
    @responses << error
    self
  end

  def perform(request, timeout:, open_timeout:)
    @requests << request
    @timeouts << {timeout: timeout, open_timeout: open_timeout}
    response = @responses.shift || Visbook::Response.new(status: 200, body: "{}")
    response.is_a?(Visbook::Response) ? response : raise(response)
  end

  def last_request = requests.last
end

module VisbookTestHelpers
  def setup
    Visbook.reset_configuration!
    @connection = FakeConnection.new
    @client = Visbook::Client.new(web_entity_id: 1, connection: @connection)
  end

  def teardown
    Visbook.reset_configuration!
  end

  def last_request = @connection.last_request

  def last_query = URI.decode_www_form(last_request.uri.query.to_s).to_h

  def last_body = JSON.parse(last_request.body)

  def assert_request(method, path, query: {})
    assert_equal method, last_request.method
    assert_equal "/api/1#{path}", last_request.uri.path
    assert_equal query, last_query
  end
end

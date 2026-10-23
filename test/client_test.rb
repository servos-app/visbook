require_relative "test_helper"
require "socket"

class ClientTest < Minitest::Test
  include VisbookTestHelpers

  class RecordingLogger
    attr_reader :messages

    def initialize
      @messages = []
    end

    def debug(message)
      @messages << message
    end
  end

  def test_raises_configuration_error_when_no_web_entity_id_is_supplied
    assert_raises(Visbook::Errors::ConfigurationError) { Visbook::Client.new }
  end

  def test_accepts_web_entity_id_from_constructor
    client = Visbook::Client.new(web_entity_id: 12345)

    assert_equal 12345, client.web_entity_id
  end

  def test_uses_global_configuration_when_constructor_argument_is_omitted
    Visbook.configure { |config| config.web_entity_id = 9999 }

    assert_equal 9999, Visbook::Client.new.web_entity_id
  end

  def test_constructor_argument_overrides_global_configuration
    Visbook.configure { |config| config.web_entity_id = 1 }

    assert_equal 2, Visbook::Client.new(web_entity_id: 2).web_entity_id
  end

  def test_accepts_session_cookie_at_construction_and_sends_it
    client = Visbook::Client.new(web_entity_id: 1, session_cookie: "VbAuth=abc", connection: @connection)

    client.get("/user")

    assert_equal "VbAuth=abc", client.session_cookie
    assert_equal "VbAuth=abc", last_request["Cookie"]
  end

  def test_sends_no_cookie_without_a_session
    @client.get("/setup")

    assert_nil last_request["Cookie"]
  end

  def test_every_documented_resource_is_exposed_and_memoized
    accessors = %i[
      availability_calendar checkout company_information gdpr giftcard
      login order_groups orders pdf pricing_calendar release_change_log
      reservations setup user validation web_products
    ]

    accessors.each do |name|
      assert_same @client.public_send(name), @client.public_send(name), "expected #{name} to be memoized"
    end
  end

  def test_prepends_api_and_web_entity_id_and_embeds_query_params
    client = Visbook::Client.new(web_entity_id: 12345, connection: @connection)

    client.get("/companyinformation")
    assert_equal "https://ws.visbook.com/api/12345/companyinformation", last_request.uri.to_s

    client.get("webproducts/2026-05-01/2026-05-03", params: {numberOfPersons: 2})
    assert_equal(
      "https://ws.visbook.com/api/12345/webproducts/2026-05-01/2026-05-03?numberOfPersons=2",
      last_request.uri.to_s
    )
  end

  def test_flattens_nested_params_joins_arrays_and_drops_nils
    @client.get("/webproducts", params: {groups: [1, 2], empty: [], skipped: nil, attributes: {haveWifi: true}})

    assert_equal({"groups" => "1,2", "attributes[haveWifi]" => "true"}, last_query)
  end

  def test_sends_accept_and_language_headers
    client = Visbook::Client.new(web_entity_id: 1, language: "nb-NO", connection: @connection)

    client.get("/setup")

    assert_equal "application/json", last_request["Accept"]
    assert_equal "nb-NO", last_request["Accept-Language"]
  end

  def test_language_falls_back_to_the_configured_default
    Visbook.configure { |config| config.default_language = "en-GB" }

    Visbook::Client.new(web_entity_id: 1, connection: @connection).get("/setup")

    assert_equal "en-GB", last_request["Accept-Language"]
  end

  def test_passes_configured_timeouts_to_the_connection
    Visbook::Client.new(web_entity_id: 1, timeout: 5, open_timeout: 2, connection: @connection).get("/setup")

    assert_equal({timeout: 5, open_timeout: 2}, @connection.timeouts.last)
  end

  def test_json_post_sets_content_type_and_serializes_the_body
    @client.post("/checkout", body: {foo: "bar"})

    assert_request "POST", "/checkout"
    assert_equal "application/json", last_request["Content-Type"]
    assert_equal '{"foo":"bar"}', last_request.body
  end

  def test_empty_json_body_is_not_sent
    @client.post("/checkout", body: {})

    assert_equal "application/json", last_request["Content-Type"]
    assert_nil last_request.body
  end

  def test_form_post_sets_content_type_and_url_encodes_the_body
    @connection.respond_with(status: 204, body: "")

    @client.post("/login/request/email", form: {email: "guest@example.com"})

    assert_equal "application/x-www-form-urlencoded", last_request["Content-Type"]
    assert_equal "email=guest%40example.com", last_request.body
  end

  def test_captures_session_cookie_from_set_cookie_header_and_resends_it
    @connection.respond_with(headers: {"Set-Cookie" => ["VbAuth=token123; Path=/; HttpOnly"]})

    @client.get("/validation/email/abc")

    assert_equal "VbAuth=token123", @client.session_cookie

    @client.get("/user")

    assert_equal "VbAuth=token123", last_request["Cookie"]
  end

  def test_keeps_the_session_cookie_when_a_response_sets_none
    @client.session_cookie = "VbAuth=abc"

    @client.get("/setup")

    assert_equal "VbAuth=abc", @client.session_cookie
  end

  def test_401_raises_authentication_error_carrying_the_api_error_message
    @connection.respond_with(status: 401, body: '{"error":"Unauthorized","errorCode":"unauthorizedError"}')

    error = assert_raises(Visbook::Errors::AuthenticationError) { @client.get("/user") }

    assert_equal "Unauthorized", error.message
    assert_equal "unauthorizedError", error.error_code
    assert_equal 401, error.code
  end

  def test_403_raises_forbidden_error
    @connection.respond_with(status: 403, body: '{"error":"Forbidden"}')

    assert_raises(Visbook::Errors::ForbiddenError) { @client.get("/user") }
  end

  def test_404_raises_not_found_error
    @connection.respond_with(status: 404, body: '{"error":"Not found"}')

    assert_raises(Visbook::Errors::NotFoundError) { @client.get("/booking/0") }
  end

  def test_400_raises_validation_error
    @connection.respond_with(status: 400, body: '{"error":"Bad","errorCode":"inputNotValid","errors":["x"]}')

    error = assert_raises(Visbook::Errors::ValidationError) { @client.get("/x") }

    assert_equal "Bad", error.message
    assert_equal "inputNotValid", error.error_code
    assert_equal ["x"], error.errors
  end

  def test_410_raises_gone_error
    @connection.respond_with(status: 410, body: '{"error":"Gone"}')

    assert_raises(Visbook::Errors::GoneError) { @client.get("/giftcard/balance/x") }
  end

  def test_412_raises_precondition_failed_error
    @connection.respond_with(status: 412, body: '{"checkoutStatus":"someReservationsExpired"}')

    error = assert_raises(Visbook::Errors::PreconditionFailedError) { @client.post("/checkout", body: {}) }

    assert_equal "HTTP 412", error.message
    assert_equal "someReservationsExpired", error.response.data["checkoutStatus"]
  end

  def test_429_raises_rate_limit_error_with_retry_after
    @connection.respond_with(status: 429, body: "", headers: {"Retry-After" => ["30"]})

    error = assert_raises(Visbook::Errors::RateLimitError) { @client.get("/x") }

    assert_equal 30, error.retry_after
  end

  def test_5xx_raises_server_error
    @connection.respond_with(status: 500, body: "boom")

    error = assert_raises(Visbook::Errors::ServerError) { @client.get("/x") }

    assert_equal "boom", error.message
  end

  def test_unmapped_status_raises_the_base_error
    @connection.respond_with(status: 409, body: "")

    error = assert_raises(Visbook::Errors::Error) { @client.get("/x") }

    assert_equal Visbook::Errors::Error, error.class
  end

  def test_read_timeout_becomes_timeout_error
    @connection.raise_error(Net::ReadTimeout)

    error = assert_raises(Visbook::Errors::TimeoutError) { @client.get("/setup") }

    assert_equal "Request timed out", error.message
  end

  def test_open_timeout_becomes_timeout_error
    @connection.raise_error(Net::OpenTimeout)

    error = assert_raises(Visbook::Errors::TimeoutError) { @client.get("/setup") }

    assert_equal "Connection timed out", error.message
  end

  def test_refused_connection_becomes_connection_error
    @connection.raise_error(Errno::ECONNREFUSED)

    assert_raises(Visbook::Errors::ConnectionError) { @client.get("/setup") }
  end

  def test_logs_request_and_response_to_the_configured_logger
    logger = RecordingLogger.new
    Visbook.configure { |config| config.logger = logger }
    @connection.respond_with(body: '{"ok":true}')

    Visbook::Client.new(web_entity_id: 1, connection: @connection).post("/checkout", body: {foo: "bar"})

    assert_equal [
      "[Visbook] POST https://ws.visbook.com/api/1/checkout",
      '[Visbook] Body: {foo: "bar"}',
      "[Visbook] Response: 200",
      '[Visbook] Body: {"ok":true}'
    ], logger.messages
  end

  def test_real_connection_wraps_the_status_body_and_every_cookie
    server = TCPServer.new("127.0.0.1", 0)
    answer = Thread.new do
      socket = server.accept
      socket.gets("\r\n\r\n")
      socket.write "HTTP/1.1 200 OK\r\nSet-Cookie: VbAuth=abc; HttpOnly\r\nSet-Cookie: Other=xyz; Path=/\r\n" \
        "Content-Length: 11\r\nConnection: close\r\n\r\n{\"ok\":true}"
      socket.close
    end
    request = Net::HTTP::Get.new(URI("http://127.0.0.1:#{server.addr[1]}/api/1/setup"))

    response = Visbook::Connection.perform(request, timeout: 5, open_timeout: 5)

    assert_equal 200, response.status
    assert_equal({"ok" => true}, response.data)
    assert_equal %w[VbAuth=abc Other=xyz], response.cookies
  ensure
    answer&.kill
    server&.close
  end

  def test_real_connection_raises_the_network_error
    request = Net::HTTP::Get.new(URI("http://127.0.0.1:1/api/1/setup"))

    assert_raises(Errno::ECONNREFUSED) { Visbook::Connection.perform(request, timeout: 1, open_timeout: 1) }
  end
end

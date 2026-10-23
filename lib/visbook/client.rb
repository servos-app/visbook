module Visbook
  # Main client for the Visbook v8 booking API.
  #
  # Every endpoint lives under `/api/{web_entity_id}/...`. The web entity id
  # is supplied once at construction time and embedded in the path of every
  # request.
  #
  # @example Anonymous (catalog) usage
  #   client = Visbook::Client.new(web_entity_id: 12345)
  #   client.company_information.retrieve
  #   client.web_products.list(from: "2026-05-01", to: "2026-05-03")
  #
  # @example Authenticated checkout flow
  #   client = Visbook::Client.new(web_entity_id: 12345)
  #   client.reservations.create(...)
  #   client.login.request_email_token(email: "guest@example.com")
  #   client.validation.email(token: "abc")  # captures session cookie
  #   client.checkout.checkout(...)
  #
  class Client
    REQUEST_CLASSES = {
      get: Net::HTTP::Get,
      post: Net::HTTP::Post,
      put: Net::HTTP::Put,
      delete: Net::HTTP::Delete
    }.freeze

    STATUS_ERRORS = {
      401 => Errors::AuthenticationError,
      403 => Errors::ForbiddenError,
      404 => Errors::NotFoundError,
      410 => Errors::GoneError,
      412 => Errors::PreconditionFailedError
    }.freeze

    attr_reader :web_entity_id, :configuration
    attr_accessor :session_cookie, :language

    def initialize(
      web_entity_id: nil, environment: nil, timeout: nil, open_timeout: nil, session_cookie: nil, language: nil,
      connection: Connection
    )
      @connection = connection
      @configuration = Visbook.configuration.merge(
        web_entity_id: web_entity_id, environment: environment, timeout: timeout, open_timeout: open_timeout,
        default_language: language
      )

      @web_entity_id = @configuration.web_entity_id
      @session_cookie = session_cookie
      @language = @configuration.default_language

      validate_configuration!
    end

    # Resource accessors

    def availability_calendar
      @availability_calendar ||= Resources::AvailabilityCalendar.new(self)
    end

    def checkout
      @checkout ||= Resources::Checkout.new(self)
    end

    def company_information
      @company_information ||= Resources::CompanyInformation.new(self)
    end

    def gdpr
      @gdpr ||= Resources::Gdpr.new(self)
    end

    def giftcard
      @giftcard ||= Resources::Giftcard.new(self)
    end

    def login
      @login ||= Resources::Login.new(self)
    end

    def order_groups
      @order_groups ||= Resources::OrderGroups.new(self)
    end

    def orders
      @orders ||= Resources::Orders.new(self)
    end

    def pdf
      @pdf ||= Resources::Pdf.new(self)
    end

    def pricing_calendar
      @pricing_calendar ||= Resources::PricingCalendar.new(self)
    end

    def release_change_log
      @release_change_log ||= Resources::ReleaseChangeLog.new(self)
    end

    def reservations
      @reservations ||= Resources::Reservations.new(self)
    end

    def setup
      @setup ||= Resources::Setup.new(self)
    end

    def user
      @user ||= Resources::User.new(self)
    end

    def validation
      @validation ||= Resources::Validation.new(self)
    end

    def web_products
      @web_products ||= Resources::WebProducts.new(self)
    end

    # HTTP methods.
    #
    # `path` is everything after `/api/{web_entity_id}` and should include a
    # leading slash. `body` is encoded as JSON; pass `form:` for
    # `application/x-www-form-urlencoded` instead (used by /login endpoints).

    def get(path, params: {})
      request(:get, path, params: params)
    end

    def post(path, body: nil, form: nil, params: {})
      request(:post, path, body: body, form: form, params: params)
    end

    def put(path, body: nil, params: {})
      request(:put, path, body: body, params: params)
    end

    def delete(path, body: nil, params: {})
      request(:delete, path, body: body, params: params)
    end

    private

    def validate_configuration!
      if web_entity_id.nil? || web_entity_id.to_s.empty?
        raise Errors::ConfigurationError,
          "web_entity_id is required. Set via Visbook.configure or pass to Client.new"
      end
    end

    def request(method, path, params: {}, body: nil, form: nil)
      uri = build_uri(path, params)
      request = build_request(method, uri, body, form)

      log_request(method, uri, body || form)

      response = perform(request)

      log_response(response)
      capture_session_cookie(response)
      handle_errors(response)

      response
    end

    def perform(request)
      @connection.perform(request, timeout: configuration.timeout, open_timeout: configuration.open_timeout)
    rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, SocketError => e
      raise Errors::ConnectionError.new("Connection failed: #{e.message}")
    rescue Net::OpenTimeout
      raise Errors::TimeoutError.new("Connection timed out")
    rescue Net::ReadTimeout
      raise Errors::TimeoutError.new("Request timed out")
    end

    def build_uri(path, params)
      url = "#{configuration.base_url}/api/#{web_entity_id}#{normalize_path(path)}"
      uri = URI(url)
      uri.query = URI.encode_www_form(flatten_params(params)) unless params.nil? || params.empty?
      uri
    end

    def normalize_path(path)
      path.start_with?("/") ? path : "/#{path}"
    end

    def build_request(method, uri, body, form)
      request = REQUEST_CLASSES.fetch(method).new(uri)
      request["Accept"] = "application/json"
      request["Accept-Language"] = language if language
      request["Cookie"] = session_cookie if session_cookie
      write_body(request, body, form)
      request
    end

    def write_body(request, body, form)
      if form
        request["Content-Type"] = "application/x-www-form-urlencoded"
        request.body = URI.encode_www_form(flatten_params(form))
      else
        request["Content-Type"] = "application/json"
        request.body = body.to_json if sendable?(body)
      end
    end

    def sendable?(body)
      !body.nil? && !(body.respond_to?(:empty?) && body.empty?)
    end

    def flatten_params(params, prefix = nil)
      params.each_with_object([]) do |(key, value), result|
        prefixed_key = prefix ? "#{prefix}[#{key}]" : key.to_s

        case value
        when Hash
          result.concat(flatten_params(value, prefixed_key))
        when Array
          # Visbook uses comma-separated arrays for query params (e.g. ?groups=1,2,3)
          # and `[]` brackets for repeated path-style arrays. Default to comma-join
          # when used as a query value; callers can pre-format if needed.
          result << [prefixed_key, value.join(",")] unless value.empty?
        when nil
          # skip
        else
          result << [prefixed_key, value.to_s]
        end
      end
    end

    def capture_session_cookie(response)
      return if response.cookies.empty?

      @session_cookie = response.cookies.join("; ")
    end

    def handle_errors(response)
      return if response.success?

      status = response.status
      message = response.error_message || "HTTP #{status}"
      details = {response: response, code: status}

      case status
      when 400, 422
        raise Errors::ValidationError.new(message, errors: extract_errors(response), **details)
      when 429
        raise Errors::RateLimitError.new(message, retry_after: response.headers["retry-after"]&.first&.to_i, **details)
      else
        raise error_class(status).new(message, **details)
      end
    end

    def error_class(status)
      STATUS_ERRORS.fetch(status) { (500..599).cover?(status) ? Errors::ServerError : Errors::Error }
    end

    def extract_errors(response)
      err = response.error
      return [] unless err.is_a?(Hash)

      err["errors"] || err["modelState"] || []
    end

    def log_request(method, uri, body)
      return unless configuration.logger

      configuration.logger.debug "[Visbook] #{method.upcase} #{uri}"
      configuration.logger.debug "[Visbook] Body: #{body}" if body
    end

    def log_response(response)
      return unless configuration.logger

      configuration.logger.debug "[Visbook] Response: #{response.status}"
      configuration.logger.debug "[Visbook] Body: #{response.raw_body}" if response.raw_body
    end
  end
end

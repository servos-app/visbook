module Visbook
  module Errors
    class Error < StandardError
      attr_reader :response, :code

      def initialize(message = nil, response: nil, code: nil)
        @response = response
        @code = code
        super(message)
      end

      # Visbook returns a string `errorCode` (PublishedExceptionErrorCode) on
      # error responses. Convenience pass-through for ergonomics.
      def error_code
        response&.error_code
      end
    end

    class AuthenticationError < Error; end

    class ForbiddenError < Error; end

    class NotFoundError < Error; end

    # 410 Gone — Visbook uses this for expired gift cards.
    class GoneError < Error; end

    # 412 Precondition Failed — checkout returns this together with a
    # CheckoutResponse describing which reservations expired.
    class PreconditionFailedError < Error; end

    class ValidationError < Error
      attr_reader :errors

      def initialize(message = nil, errors: [], **kwargs)
        @errors = errors
        super(message, **kwargs)
      end
    end

    class RateLimitError < Error
      attr_reader :retry_after

      def initialize(message = nil, retry_after: nil, **kwargs)
        @retry_after = retry_after
        super(message, **kwargs)
      end
    end

    class ServerError < Error; end

    class ConnectionError < Error; end

    class TimeoutError < Error; end

    class ConfigurationError < Error; end
  end
end

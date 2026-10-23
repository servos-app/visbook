module Visbook
  # Wraps API responses with convenient accessors.
  #
  # Visbook returns plain JSON objects/arrays without an envelope. Errors
  # use the {ErrorResponseViewModel} shape: `{ "error": "...", "errorCode": "..." }`.
  class Response
    attr_reader :status, :headers, :raw_body, :body, :cookies

    def initialize(status:, body:, headers: {})
      @status = status
      @headers = headers.to_h { |name, values| [name.to_s.downcase, Array(values)] }
      @raw_body = body
      @body = parse_body(body)
      @cookies = @headers.fetch("set-cookie", []).map { |cookie| cookie.split(";", 2).first.strip }
    end

    def success?
      status >= 200 && status < 300
    end

    # Decoded response body (Hash, Array, or nil).
    def data
      body
    end

    # Returns the parsed error payload (Hash) when the request failed.
    def error
      return nil if success?

      case body
      when Hash, String
        body
      end
    end

    # Convenience accessor for the human-readable error string Visbook puts
    # under the `error` key of {ErrorResponseViewModel}.
    def error_message
      case error
      when Hash
        error["error"] || error["message"] || error["title"]
      when String
        error
      end
    end

    # Convenience accessor for the {PublishedExceptionErrorCode} string
    # Visbook attaches to error responses.
    def error_code
      return nil unless error.is_a?(Hash)

      error["errorCode"]
    end

    private

    def parse_body(body)
      return nil if body.nil? || body.empty?

      JSON.parse(body)
    rescue JSON::ParserError
      body
    end
  end
end

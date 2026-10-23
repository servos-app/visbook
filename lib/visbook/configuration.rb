module Visbook
  # Configuration for the Visbook client.
  #
  # The Visbook v8 API scopes every endpoint to a `webentity` segment in
  # the URL path (`/api/{webentity}/...`). This is the customer/installation
  # identifier you would otherwise call a "web identity id".
  #
  # @example
  #   Visbook.configure do |config|
  #     config.web_entity_id = 12345
  #     config.default_language = "en-GB"
  #     config.timeout = 30
  #   end
  class Configuration
    ENVIRONMENTS = {
      production: "https://ws.visbook.com"
    }.freeze

    attr_accessor :web_entity_id, :timeout, :open_timeout, :logger, :default_language
    attr_reader :environment

    def initialize
      @web_entity_id = nil
      @environment = :production
      @timeout = 30
      @open_timeout = 10
      @logger = nil
      @default_language = nil
    end

    def environment=(env)
      env = env.to_sym
      unless ENVIRONMENTS.key?(env)
        raise ArgumentError, "Invalid environment: #{env}. Valid options: #{ENVIRONMENTS.keys.join(", ")}"
      end

      @environment = env
    end

    def merge(overrides)
      dup.tap do |config|
        overrides.compact.each { |name, value| config.public_send(:"#{name}=", value) }
      end
    end

    def base_url
      ENVIRONMENTS.fetch(@environment)
    end
  end
end

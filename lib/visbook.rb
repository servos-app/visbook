require "date"
require "json"
require "net/http"
require "uri"

require_relative "visbook/version"
require_relative "visbook/configuration"
require_relative "visbook/errors"
require_relative "visbook/response"
require_relative "visbook/connection"
require_relative "visbook/object"
require_relative "visbook/objects"
require_relative "visbook/resource"
require_relative "visbook/resources"
require_relative "visbook/client"

# Visbook API Ruby client
#
# A clean, idiomatic Ruby library for the Visbook v8 booking API.
# Endpoint base: https://ws.visbook.com/api/{web_entity_id}/...
#
# Visbook scopes every request to a single web entity (installation) via a
# path segment. End-users authenticate with a one-time-token flow on
# {Visbook::Resources::Login} + {Visbook::Resources::Validation} which
# returns an httpOnly cookie required for {Visbook::Resources::Checkout}
# and {Visbook::Resources::User}.
#
# @example
#   Visbook.configure do |config|
#     config.web_entity_id = 12345
#     config.default_language = "en-GB"
#   end
#
#   client = Visbook::Client.new
#   client.web_products.list(from: "2026-05-01", to: "2026-05-03")
module Visbook
  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    def reset_configuration!
      @configuration = Configuration.new
    end
  end
end

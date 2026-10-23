module Visbook
  # Typed wrappers for the most-commonly-consumed Visbook response shapes.
  # Every object accepts the raw hash, exposes typed accessors for known
  # camelCase keys, and falls back to hash-style access for everything else.
  module Objects
  end
end

# Leaf / shared objects first
require_relative "objects/currency"
require_relative "objects/time_zone"
require_relative "objects/description"
require_relative "objects/web_product_image"
require_relative "objects/web_entity_image"
require_relative "objects/color"
require_relative "objects/enabled_services"
require_relative "objects/enabled_features"
require_relative "objects/time_settings"
require_relative "objects/analytic"
require_relative "objects/anonymization"
require_relative "objects/cancellation_rules"
require_relative "objects/product_group"
require_relative "objects/merchandise"
require_relative "objects/service"
require_relative "objects/available_number_of_people"
require_relative "objects/price_age_group"
require_relative "objects/step"
require_relative "objects/price"
require_relative "objects/web_product_availability"
require_relative "objects/payment_type_settings"

# Higher-level objects
require_relative "objects/company_information"
require_relative "objects/setup"
require_relative "objects/web_product"
require_relative "objects/web_product_unit"
require_relative "objects/web_products_response"
require_relative "objects/availability_calendar_item"
require_relative "objects/price_calendar_item"
require_relative "objects/giftcard"
require_relative "objects/field"
require_relative "objects/terms"
require_relative "objects/web_entity_payment_settings"
require_relative "objects/reservation"
require_relative "objects/reservation_company_relation"
require_relative "objects/checkout_response"
require_relative "objects/person"
require_relative "objects/booking"
require_relative "objects/pdf"
require_relative "objects/order"
require_relative "objects/order_group"
require_relative "objects/release_change_log"
require_relative "objects/user"

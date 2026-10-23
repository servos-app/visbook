module Visbook
  module Objects
    class Setup < Visbook::Object
      attribute :name
      attribute :test_mode_enabled
      attribute :use_periodization
      attribute :use_notes
      attribute :use_guests_names
      attribute :cancellation_settings_id
      attribute :allow_customer_registration
      attribute :colors, type: Color
      attribute :enabled_services, type: EnabledServices
      attribute :time_settings, type: TimeSettings
      array_attribute :images, type: WebEntityImage
      attribute :properties
      array_attribute :analytics, type: Analytic
      attribute :enabled_languages
      attribute :time_zone_info, type: TimeZone
      attribute :enabled_features, type: EnabledFeatures
    end
  end
end

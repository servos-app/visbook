module Visbook
  module Objects
    class WebProductForCalendar < Visbook::Object
      attribute :id
      attribute :type
      attribute :encrypted_company_id
      attribute :availability, type: WebProductAvailability
    end

    class AvailabilityCalendarItem < Visbook::Object
      attribute :date
      array_attribute :web_products, type: WebProductForCalendar
    end
  end
end

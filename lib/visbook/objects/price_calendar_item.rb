module Visbook
  module Objects
    class CalendarWebProductPrice < Visbook::Object
      attribute :id
      attribute :name
      attribute :price_type
      attribute :discount1
      attribute :discount2
      attribute :price_per_step
      attribute :base_price
      attribute :customer_category_id
      attribute :from
      attribute :to
      attribute :pension_type
      attribute :price_age_group
      attribute :available_number_of_people
    end

    class WebProductCalculatedPrice < Visbook::Object
      attribute :calculated_price
      array_attribute :web_product_prices, type: CalendarWebProductPrice
    end

    class PriceCalendarItem < Visbook::Object
      attribute :date
      array_attribute :prices, type: WebProductCalculatedPrice
    end
  end
end

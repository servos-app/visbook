module Visbook
  module Objects
    class PriceAgeGroup < Visbook::Object
      attribute :id
      attribute :name
      attribute :age_from
      attribute :age_to
      attribute :price_adjustment_percent
    end
  end
end

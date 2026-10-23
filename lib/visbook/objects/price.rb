module Visbook
  module Objects
    class Price < Visbook::Object
      attribute :id
      attribute :name
      attribute :price_type
      attribute :pension_type
      attribute :discount1
      attribute :discount2
      attribute :original_price_per_step
      attribute :price_per_step
      attribute :calculated_price
      array_attribute :available_number_of_people, type: AvailableNumberOfPeople
      array_attribute :steps, type: Step
      array_attribute :price_age_group, type: PriceAgeGroup
    end
  end
end

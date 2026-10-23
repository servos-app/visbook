module Visbook
  module Objects
    class Booking < Visbook::Object
      attribute :id
      attribute :standard_name
      attribute :name
      attribute :notes
      attribute :guests_names
      attribute :number_of_people
      attribute :count
      attribute :total
      attribute :price
      attribute :unit_type
      attribute :status
      attribute :type
      attribute :from_date
      attribute :to_date
      array_attribute :sub_bookings, type: Booking
      array_attribute :people, type: Person
    end
  end
end

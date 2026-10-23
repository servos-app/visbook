module Visbook
  module Objects
    class TimeSettings < Visbook::Object
      attribute :closing_time
      attribute :opening_date
      attribute :closing_date
      attribute :maximum_booking_length
      attribute :minimum_booking_length
    end
  end
end

module Visbook
  module Objects
    class Choice < Visbook::Object
      attribute :code
      attribute :label
    end

    class Limitation < Visbook::Object
      attribute :max_length
      attribute :pattern
    end

    class Field < Visbook::Object
      attribute :name
      attribute :label
      attribute :field_type
      attribute :limitations, type: Limitation
      array_attribute :choices, type: Choice
    end
  end
end

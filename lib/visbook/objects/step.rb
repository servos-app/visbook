module Visbook
  module Objects
    class Step < Visbook::Object
      attribute :from
      attribute :to
    end

    class StepUnits < Visbook::Object
      attribute :available_units
      attribute :from
      attribute :to
    end
  end
end

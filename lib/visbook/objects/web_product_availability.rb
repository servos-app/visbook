module Visbook
  module Objects
    class WebProductAvailability < Visbook::Object
      attribute :available
      attribute :reason
      attribute :reason_text
      array_attribute :steps, type: StepUnits
    end
  end
end

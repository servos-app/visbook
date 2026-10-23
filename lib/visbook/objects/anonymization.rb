module Visbook
  module Objects
    class Anonymization < Visbook::Object
      attribute :can_be_anonymized
      attribute :anonymized_at, key: "when"
    end
  end
end

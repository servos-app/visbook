module Visbook
  module Objects
    class PaymentTypeSettings < Visbook::Object
      attribute :pay_now
      attribute :type
      attribute :status
      attribute :paid
      attribute :number_of_days
      attribute :never_due_after
      attribute :per_unit
    end
  end
end

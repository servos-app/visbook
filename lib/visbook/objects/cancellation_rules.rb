module Visbook
  module Objects
    class CancellationRules < Visbook::Object
      attribute :has_insurance
      attribute :fee
      attribute :can_cancel_until
      attribute :has_invoices
    end
  end
end

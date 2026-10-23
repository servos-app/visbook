module Visbook
  module Objects
    class WebEntityPaymentSettings < Visbook::Object
      attribute :payment_types
      attribute :no_online_payment, type: PaymentTypeSettings
      attribute :net_axept, type: PaymentTypeSettings
      attribute :partial_payment, type: PaymentTypeSettings
      attribute :invoice, type: PaymentTypeSettings
    end
  end
end

module Visbook
  module Objects
    class OrderGroup < Visbook::Object
      attribute :id
      attribute :registration_date
      attribute :currency, type: Currency
      attribute :encrypted_booking_company_id
      attribute :cancellation_rules, type: CancellationRules
      array_attribute :orders, type: Order

      # Present on /ordergroups/{token}/{orderGroupId}/{orderId}
      attribute :due_at
      attribute :to_be_paid
      attribute :epay_token
    end
  end
end

module Visbook
  module Objects
    class CheckoutResponse < Visbook::Object
      attribute :terminal_url
      attribute :checkout_status
      array_attribute :expired_reservations, type: ReservationCompanyRelation
      attribute :giftcards_balance
    end
  end
end

module Visbook
  module Objects
    class Order < Visbook::Object
      attribute :id
      attribute :ordered_at
      attribute :last_changed_at
      attribute :cancelled_at
      attribute :from
      attribute :to
      attribute :status
      attribute :order_group_id
      array_attribute :bookings, type: Booking
      attribute :bookings_count
      attribute :order_total_price
      attribute :order_total_paid
      attribute :currency, type: Currency
      attribute :encrypted_company_id
      attribute :pdfs_endpoint
      array_attribute :pdfs, type: Visbook::Objects::Pdf
    end
  end
end

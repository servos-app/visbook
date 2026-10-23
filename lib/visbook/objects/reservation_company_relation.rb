module Visbook
  module Objects
    class ReservationCompanyRelation < Visbook::Object
      attribute :reservation_id
      attribute :encrypted_company_id
    end
  end
end

module Visbook
  module Objects
    class User < Visbook::Object
      attribute :id
      attribute :encrypted_company_id
      attribute :company
      attribute :city
      attribute :country
      attribute :first_name
      attribute :last_name
      attribute :address
      attribute :email
      attribute :phone
      attribute :zip_code
      attribute :mobile
      attribute :passport_number
      attribute :title
      attribute :extra1
      attribute :extra2
      attribute :extra3
      attribute :extra4
      attribute :extra5
      attribute :followup_accepted
      attribute :organization_number
      attribute :anonymization, type: Anonymization
    end
  end
end

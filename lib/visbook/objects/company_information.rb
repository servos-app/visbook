module Visbook
  module Objects
    class CompanyInformation < Visbook::Object
      attribute :id
      attribute :name
      attribute :address1
      attribute :address2
      attribute :zip_code
      attribute :city
      attribute :phone
      attribute :fax
      attribute :tax_no
      attribute :email
      attribute :website
      attribute :org_no
      attribute :country_code
      attribute :country
      attribute :phone_prefix
      attribute :properties
      attribute :currency, type: Currency
      attribute :time_zone_info, type: TimeZone
    end
  end
end

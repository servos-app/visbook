module Visbook
  module Objects
    class Merchandise < Visbook::Object
      attribute :id
      attribute :encrypted_company_id
      attribute :name
      attribute :default_name
      attribute :price
    end
  end
end

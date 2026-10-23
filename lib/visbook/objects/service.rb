module Visbook
  module Objects
    class Service < Visbook::Object
      attribute :id
      attribute :encrypted_company_id
      attribute :name
      attribute :default_name
      attribute :price
      attribute :service_type
      attribute :service_relation_type
      attribute :rules
      attribute :product_group, type: ProductGroup
    end
  end
end

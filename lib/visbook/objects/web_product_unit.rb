module Visbook
  module Objects
    class WebProductUnit < Visbook::Object
      attribute :name
      attribute :default_name
      attribute :unit_name
      attribute :default_unit_name
      attribute :web_product_id
      attribute :sort_index
      attribute :type
      attribute :max_people
      attribute :min_people
      attribute :default_people
      attribute :encrypted_company_id
      attribute :description, type: Description
      array_attribute :images, type: WebProductImage
      array_attribute :additional_services, type: Service
      array_attribute :additional_merchandises, type: Merchandise
      attribute :product_group, type: ProductGroup
      attribute :properties
    end
  end
end

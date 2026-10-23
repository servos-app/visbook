module Visbook
  module Objects
    class WebProduct < Visbook::Object
      attribute :id
      attribute :type
      attribute :sort_index
      attribute :encrypted_company_id
      attribute :name
      attribute :default_name
      attribute :unit_name
      attribute :default_unit_name
      attribute :max_people
      attribute :min_people
      attribute :default_people
      attribute :description, type: Description
      attribute :availability, type: WebProductAvailability
      array_attribute :prices, type: Price
      array_attribute :images, type: WebProductImage
      array_attribute :additional_services, type: Service
      array_attribute :additional_merchandises, type: Merchandise
      attribute :product_group, type: ProductGroup
      attribute :properties
    end
  end
end

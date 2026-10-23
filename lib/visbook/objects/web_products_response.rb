module Visbook
  module Objects
    class WebProductsResponse < Visbook::Object
      array_attribute :accommodations, type: WebProduct
      array_attribute :activities, type: WebProduct
      array_attribute :restaurants, type: WebProduct
    end
  end
end

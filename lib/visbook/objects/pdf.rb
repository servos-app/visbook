module Visbook
  module Objects
    class Pdf < Visbook::Object
      attribute :name
      attribute :url
      attribute :title
    end

    class OrderPdf < Visbook::Object
      attribute :url
      attribute :type
    end
  end
end

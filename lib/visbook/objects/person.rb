module Visbook
  module Objects
    class Person < Visbook::Object
      attribute :first_name
      attribute :last_name
      attribute :address
      attribute :zip_code
      attribute :phone
      attribute :email
      attribute :country
      attribute :title
      attribute :last_changed_at
    end
  end
end

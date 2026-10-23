module Visbook
  module Resources
    # Giftcard — look up a gift card balance by id.
    class Giftcard < Resource
      # GET /api/{webentity}/giftcard/balance/{id}
      def balance(id)
        client.get("/giftcard/balance/#{id}")
      end
    end
  end
end

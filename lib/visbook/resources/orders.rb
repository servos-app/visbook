module Visbook
  module Resources
    # Orders — authenticated guest's own orders.
    class Orders < Resource
      # GET /api/{webentity}/orders
      def list
        client.get("/orders")
      end

      # GET /api/{webentity}/orders/{id}
      #
      # @param encrypted_company_id [String, nil] when provided, fetches the
      #   order from a related company instead of the current one.
      def retrieve(id, encrypted_company_id: nil)
        params = {}
        params[:encryptedCompanyId] = encrypted_company_id if encrypted_company_id
        client.get("/orders/#{id}", params: params)
      end
    end
  end
end

module Visbook
  module Resources
    # OrderGroups — booking confirmations, available to the authenticated
    # customer or via a temporary `token` returned by checkout for the
    # forwarding `successUrl`.
    class OrderGroups < Resource
      # GET /api/{webentity}/ordergroups
      def list
        client.get("/ordergroups")
      end

      # GET /api/{webentity}/ordergroups/{id}
      def retrieve(id)
        client.get("/ordergroups/#{id}")
      end

      # GET /api/{webentity}/ordergroups/{token}/{orderGroupId}/{orderId}
      #
      # Anonymous fetch via the post-checkout access token. Returns the
      # order group plus a due-for-payment date.
      def retrieve_with_token(token:, order_group_id:, order_id:)
        client.get("/ordergroups/#{token}/#{order_group_id}/#{order_id}")
      end

      # PUT /api/{webentity}/ordergroups?id=
      #
      # Refund the specified order group. Authenticated.
      def refund(id)
        client.put("/ordergroups", params: {id: id})
      end
    end
  end
end

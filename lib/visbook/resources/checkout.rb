module Visbook
  module Resources
    # Checkout — payment types, terms collection, and the actual checkout
    # call. The {#checkout} call requires an authenticated cookie obtained
    # from {Resources::Validation}.
    class Checkout < Resource
      # POST /api/{webentity}/checkout/userinfo
      #
      # Returns the customer fields the guest needs to fill in for the
      # supplied reservations.
      #
      # @param reservations [Array<Hash>] {ReservationViewModel} entries.
      def user_info(reservations)
        client.post("/checkout/userinfo", body: reservations)
      end

      # GET /api/{webentity}/checkout/paymenttypes
      def payment_types
        client.get("/checkout/paymenttypes")
      end

      # POST /api/{webentity}/checkout
      #
      # Authenticated. The body should match {CheckoutModel} — at minimum:
      # reservations, successUrl, errorUrl, paymentType, amount, customer,
      # acceptedTerms.
      def checkout(body)
        client.post("/checkout", body: body)
      end

      # POST /api/{webentity}/checkout/payorder
      #
      # Pay a previously-created order using {PaySpecificOrderModel}.
      def pay_order(body)
        client.post("/checkout/payorder", body: body)
      end
    end
  end
end

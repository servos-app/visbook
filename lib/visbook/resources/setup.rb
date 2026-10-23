module Visbook
  module Resources
    # Setup — webentity-level configuration: enabled features, languages,
    # cancellation rules, branding, and the current terms of sale.
    class Setup < Resource
      # GET /api/{webentity}/setup
      def retrieve
        client.get("/setup")
      end

      # POST /api/{webentity}/setup/terms
      #
      # @param reservations [Array<Hash>] {ReservationViewModel} entries.
      def terms(reservations)
        client.post("/setup/terms", body: reservations)
      end
    end
  end
end

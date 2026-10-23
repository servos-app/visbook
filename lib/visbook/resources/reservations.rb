module Visbook
  module Resources
    # Reservations — capacity holds. Reservations expire after 30 seconds
    # without a {#ping}; the hard cap is 30 minutes regardless. The
    # checkout flow extends the lifetime by 25 minutes when the guest is
    # forwarded to the payment processor.
    class Reservations < Resource
      # POST /api/{webentity}/reservations
      #
      # @param body [Hash] {ReservationRequestModel} (fromDate, toDate,
      #   priceId, numberOfPeople, webProductId, ...)
      def create(body)
        client.post("/reservations", body: body)
      end

      # POST /api/{webentity}/reservations/ping
      #
      # @param reservations [Array<Hash>] {ReservationViewModel} entries.
      def ping(reservations)
        client.post("/reservations/ping", body: reservations)
      end

      # PUT /api/{webentity}/reservations/{encryptedCompanyId}/{reservationId}
      def update(encrypted_company_id:, reservation_id:, body:)
        client.put("/reservations/#{encrypted_company_id}/#{reservation_id}", body: body)
      end

      # DELETE /api/{webentity}/reservations
      #
      # @param reservation [Hash] {ReservationViewModel}
      def cancel(reservation)
        client.delete("/reservations", body: reservation)
      end
    end
  end
end

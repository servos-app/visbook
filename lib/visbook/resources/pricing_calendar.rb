module Visbook
  module Resources
    # PricingCalendar — lowest available price per day across a month.
    class PricingCalendar < Resource
      # GET /api/{webentity}/pricingcalendar
      #
      # @param month [String, Date] yyyy-MM
      # @param guests_ages [String, Array<Integer>] comma-separated ages
      # @param booking_type [String] "accommodation" or "activity"
      # @param standard_id [Integer]
      def get(month:, guests_ages:, booking_type:, standard_id:)
        params = {
          month: format_month(month),
          guestsAges: Array(guests_ages).join(","),
          bookingType: booking_type,
          standardId: standard_id
        }
        client.get("/pricingcalendar", params: params)
      end

      private

      def format_month(month)
        case month
        when Date, Time
          month.strftime("%Y-%m")
        else
          month.to_s
        end
      end
    end
  end
end

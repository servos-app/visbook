module Visbook
  module Resources
    # AvailabilityCalendar — per-day availability for one or more web products.
    class AvailabilityCalendar < Resource
      # GET /api/{webentity}/availability/{webProductsIds}/{month}
      #
      # @param web_product_ids [Array<Integer>, Integer]
      # @param month [String, Date] Format yyyy-MM
      def get(web_product_ids:, month:)
        ids = Array(web_product_ids).join(",")
        client.get("/availability/#{ids}/#{format_month(month)}")
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

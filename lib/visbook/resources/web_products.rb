module Visbook
  module Resources
    # WebProducts — bookable items (accommodations, activities, restaurants).
    #
    # Three lookup styles:
    # * {#all} — every published product, no period.
    # * {#list} — products available within a date range.
    # * {#retrieve} — one product within a date range.
    class WebProducts < Resource
      # GET /api/{webentity}/webproducts
      def all(groups: nil, attributes: nil)
        client.get("/webproducts", params: build_filters(groups, attributes))
      end

      # GET /api/{webentity}/webproducts/{from}/{to}
      def list(from:, to:, number_of_persons: nil, groups: nil, attributes: nil)
        params = build_filters(groups, attributes)
        params[:numberOfPersons] = number_of_persons if number_of_persons
        client.get("/webproducts/#{format_date(from)}/#{format_date(to)}", params: params)
      end

      # GET /api/{webentity}/webproducts/{from}/{to}/{webProductId}
      def retrieve(web_product_id, from:, to:, number_of_persons: nil)
        params = {}
        params[:numberOfPersons] = number_of_persons if number_of_persons
        client.get(
          "/webproducts/#{format_date(from)}/#{format_date(to)}/#{web_product_id}",
          params: params
        )
      end

      private

      def build_filters(groups, attributes)
        params = {}
        params[:groups] = Array(groups).join(",") if groups && !Array(groups).empty?
        params[:attributes] = attributes if attributes && !attributes.empty?
        params
      end

      def format_date(date)
        case date
        when Date, Time
          date.strftime("%Y-%m-%d")
        else
          date.to_s
        end
      end
    end
  end
end

require_relative "../test_helper"

class PricingCalendarTest < Minitest::Test
  include VisbookTestHelpers

  def test_get_sends_all_required_query_params_with_formatted_month_and_ages
    @client.pricing_calendar.get(
      month: Date.new(2026, 5, 1),
      guests_ages: [30, 30],
      booking_type: "accommodation",
      standard_id: 7
    )

    assert_request "GET", "/pricingcalendar", query: {
      "month" => "2026-05",
      "guestsAges" => "30,30",
      "bookingType" => "accommodation",
      "standardId" => "7"
    }
  end
end

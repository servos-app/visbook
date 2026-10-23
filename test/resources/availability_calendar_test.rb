require_relative "../test_helper"

class AvailabilityCalendarTest < Minitest::Test
  include VisbookTestHelpers

  def test_get_joins_ids_and_forwards_a_string_month
    @client.availability_calendar.get(web_product_ids: [1, 2, 3], month: "2026-05")

    assert_request "GET", "/availability/1,2,3/2026-05"
  end

  def test_get_formats_date_months_as_year_and_month
    @client.availability_calendar.get(web_product_ids: 77, month: Date.new(2026, 5, 15))

    assert_request "GET", "/availability/77/2026-05"
  end
end

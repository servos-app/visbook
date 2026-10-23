require_relative "../test_helper"

class WebProductsTest < Minitest::Test
  include VisbookTestHelpers

  def test_all_gets_webproducts_with_no_params_by_default
    @client.web_products.all

    assert_request "GET", "/webproducts"
    assert_nil last_request.uri.query
  end

  def test_all_joins_the_groups_filter_as_comma_separated_values
    @client.web_products.all(groups: [1, 2, 3])

    assert_request "GET", "/webproducts", query: {"groups" => "1,2,3"}
  end

  def test_all_skips_empty_filters
    @client.web_products.all(groups: [], attributes: {})

    assert_nil last_request.uri.query
  end

  def test_all_forwards_the_attributes_filter_as_a_hash
    @client.web_products.all(attributes: {haveWifi: "true"})

    assert_request "GET", "/webproducts", query: {"attributes[haveWifi]" => "true"}
  end

  def test_list_gets_webproducts_for_the_formatted_dates
    @client.web_products.list(from: Date.new(2026, 5, 1), to: Date.new(2026, 5, 3))

    assert_request "GET", "/webproducts/2026-05-01/2026-05-03"
  end

  def test_list_passes_number_of_persons
    @client.web_products.list(from: "2026-05-01", to: "2026-05-03", number_of_persons: 2)

    assert_request "GET", "/webproducts/2026-05-01/2026-05-03", query: {"numberOfPersons" => "2"}
  end

  def test_retrieve_includes_the_product_id
    @client.web_products.retrieve(77, from: "2026-05-01", to: "2026-05-03", number_of_persons: 1)

    assert_request "GET", "/webproducts/2026-05-01/2026-05-03/77", query: {"numberOfPersons" => "1"}
  end
end

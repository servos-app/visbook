require_relative "../test_helper"

class OrdersTest < Minitest::Test
  include VisbookTestHelpers

  def test_list_gets_orders
    @client.orders.list

    assert_request "GET", "/orders"
  end

  def test_retrieve_gets_orders_by_id_without_the_encrypted_company_id_by_default
    @client.orders.retrieve(55)

    assert_request "GET", "/orders/55"
  end

  def test_retrieve_forwards_encrypted_company_id_as_a_query_param_when_given
    @client.orders.retrieve(55, encrypted_company_id: "abc")

    assert_request "GET", "/orders/55", query: {"encryptedCompanyId" => "abc"}
  end
end

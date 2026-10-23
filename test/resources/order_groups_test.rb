require_relative "../test_helper"

class OrderGroupsTest < Minitest::Test
  include VisbookTestHelpers

  def test_list_gets_ordergroups
    @client.order_groups.list

    assert_request "GET", "/ordergroups"
  end

  def test_retrieve_gets_ordergroups_by_id
    @client.order_groups.retrieve(123)

    assert_request "GET", "/ordergroups/123"
  end

  def test_retrieve_with_token_uses_the_three_segment_path
    @client.order_groups.retrieve_with_token(token: "tok", order_group_id: 12, order_id: 34)

    assert_request "GET", "/ordergroups/tok/12/34"
  end

  def test_refund_puts_ordergroups_with_the_id_query_param
    @client.order_groups.refund(999)

    assert_request "PUT", "/ordergroups", query: {"id" => "999"}
  end
end

require_relative "../test_helper"

class GiftcardTest < Minitest::Test
  include VisbookTestHelpers

  def test_balance_gets_giftcard_balance_by_id
    @client.giftcard.balance("ABC-123")

    assert_request "GET", "/giftcard/balance/ABC-123"
  end
end

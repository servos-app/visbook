require_relative "../test_helper"

class CheckoutTest < Minitest::Test
  include VisbookTestHelpers

  def test_user_info_posts_reservations_to_checkout_userinfo
    @client.checkout.user_info([{reservationId: 1, encryptedCompanyId: "abc"}])

    assert_request "POST", "/checkout/userinfo"
    assert_equal [{"reservationId" => 1, "encryptedCompanyId" => "abc"}], last_body
  end

  def test_payment_types_gets_checkout_paymenttypes
    @client.checkout.payment_types

    assert_request "GET", "/checkout/paymenttypes"
  end

  def test_checkout_posts_to_checkout
    body = {
      amount: 100, customer: {}, paymentType: "noOnlinePayment", reservations: [],
      successUrl: "u", errorUrl: "e", acceptedTerms: true
    }

    @client.checkout.checkout(body)

    assert_request "POST", "/checkout"
    assert_equal JSON.parse(body.to_json), last_body
  end

  def test_pay_order_posts_to_checkout_payorder
    body = {orderId: 1, orderGroupId: 2, token: "t", amount: 50, successUrl: "u", errorUrl: "e", acceptedTerms: true}

    @client.checkout.pay_order(body)

    assert_request "POST", "/checkout/payorder"
    assert_equal JSON.parse(body.to_json), last_body
  end
end

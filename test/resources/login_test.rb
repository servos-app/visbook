require_relative "../test_helper"

class LoginTest < Minitest::Test
  include VisbookTestHelpers

  def test_request_email_token_posts_form_encoded_email
    @client.login.request_email_token(email: "u@example.com")

    assert_request "POST", "/login/request/email"
    assert_equal "application/x-www-form-urlencoded", last_request["Content-Type"]
    assert_equal "email=u%40example.com", last_request.body
  end

  def test_request_sms_token_posts_form_encoded_country_code_and_phone_number
    @client.login.request_sms_token(country_code: "47", phone_number: "12345678")

    assert_request "POST", "/login/request/sms"
    assert_equal "application/x-www-form-urlencoded", last_request["Content-Type"]
    assert_equal "countryCode=47&phoneNumber=12345678", last_request.body
  end

  def test_logout_posts_and_clears_session_cookie
    @client.session_cookie = "VbAuth=abc"

    @client.login.logout

    assert_request "POST", "/logout"
    assert_equal "VbAuth=abc", last_request["Cookie"]
    assert_nil @client.session_cookie
  end
end

require_relative "../test_helper"

class ValidationTest < Minitest::Test
  include VisbookTestHelpers

  def test_email_gets_the_path_with_the_token
    @client.validation.email(token: "abc123")

    assert_request "GET", "/validation/email/abc123"
  end

  def test_mobile_gets_the_mobile_path
    @client.validation.mobile(token: "xyz")

    assert_request "GET", "/validation/mobile/xyz"
  end
end

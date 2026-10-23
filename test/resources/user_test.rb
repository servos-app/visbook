require_relative "../test_helper"

class UserTest < Minitest::Test
  include VisbookTestHelpers

  def test_retrieve_gets_user
    @client.user.retrieve

    assert_request "GET", "/user"
  end

  def test_update_puts_user_with_the_supplied_body
    @client.user.update(firstName: "Ada")

    assert_request "PUT", "/user"
    assert_equal({"firstName" => "Ada"}, last_body)
  end

  def test_anonymize_deletes_user
    @client.user.anonymize

    assert_request "DELETE", "/user"
    assert_nil last_request.body
  end
end

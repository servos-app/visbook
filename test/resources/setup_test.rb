require_relative "../test_helper"

class SetupTest < Minitest::Test
  include VisbookTestHelpers

  def test_retrieve_gets_setup
    @client.setup.retrieve

    assert_request "GET", "/setup"
  end

  def test_terms_posts_the_reservation_list_to_setup_terms
    @client.setup.terms([{reservationId: 1, encryptedCompanyId: "abc"}])

    assert_request "POST", "/setup/terms"
    assert_equal [{"reservationId" => 1, "encryptedCompanyId" => "abc"}], last_body
  end
end

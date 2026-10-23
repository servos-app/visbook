require_relative "../test_helper"

class ReservationsTest < Minitest::Test
  include VisbookTestHelpers

  def test_create_posts_the_request_body_to_reservations
    body = {webProductId: 1, fromDate: "2026-05-01", toDate: "2026-05-03", priceId: 9, numberOfPeople: 2}

    @client.reservations.create(body)

    assert_request "POST", "/reservations"
    assert_equal JSON.parse(body.to_json), last_body
  end

  def test_ping_posts_the_reservation_array_to_reservations_ping
    @client.reservations.ping([{reservationId: 1, encryptedCompanyId: "abc"}])

    assert_request "POST", "/reservations/ping"
    assert_equal [{"reservationId" => 1, "encryptedCompanyId" => "abc"}], last_body
  end

  def test_update_puts_to_reservations_by_encrypted_company_id_and_reservation_id
    @client.reservations.update(encrypted_company_id: "abc", reservation_id: 42, body: {numberOfPeople: 3})

    assert_request "PUT", "/reservations/abc/42"
    assert_equal({"numberOfPeople" => 3}, last_body)
  end

  def test_cancel_deletes_reservations_with_the_reservation_body
    @client.reservations.cancel(reservationId: 1, encryptedCompanyId: "abc")

    assert_request "DELETE", "/reservations"
    assert_equal({"reservationId" => 1, "encryptedCompanyId" => "abc"}, last_body)
  end
end

require_relative "test_helper"

class ResponseTest < Minitest::Test
  def test_success_for_2xx
    [200, 201, 202, 204].each do |status|
      assert response_for(status, "{}").success?
    end
  end

  def test_not_success_for_non_2xx
    [301, 400, 401, 404, 410, 412, 500].each do |status|
      refute response_for(status, "{}").success?
    end
  end

  def test_data_exposes_parsed_json_object
    assert_equal({"id" => 1, "name" => "x"}, response_for(200, '{"id":1,"name":"x"}').data)
  end

  def test_data_exposes_parsed_json_array
    assert_equal [1, 2, 3], response_for(200, "[1,2,3]").data
  end

  def test_error_returns_body_hash_on_failure
    response = response_for(400, '{"error":"Bad","errorCode":"inputNotValid"}')

    assert_equal({"error" => "Bad", "errorCode" => "inputNotValid"}, response.error)
    assert_equal "Bad", response.error_message
    assert_equal "inputNotValid", response.error_code
  end

  def test_error_returns_nil_on_success
    assert_nil response_for(200, "{}").error
  end

  def test_body_is_nil_for_empty_payload
    assert_nil response_for(204, "").body
    assert_nil response_for(204, nil).body
  end

  def test_body_returns_raw_string_when_json_parse_fails
    response = response_for(500, "boom")

    assert_equal "boom", response.body
    assert_equal "boom", response.raw_body
    assert_equal "boom", response.error_message
  end

  def test_cookies_are_extracted_from_set_cookie_headers
    response = Visbook::Response.new(
      status: 200, body: "{}", headers: {"set-cookie" => ["VbAuth=abc; Path=/; HttpOnly", "Other=xyz"]}
    )

    assert_equal ["VbAuth=abc", "Other=xyz"], response.cookies
  end

  def test_headers_are_keyed_by_lower_case_name
    response = Visbook::Response.new(status: 200, body: "{}", headers: {"Retry-After" => "30"})

    assert_equal({"retry-after" => ["30"]}, response.headers)
    assert_empty response.cookies
  end

  private

  def response_for(status, body)
    Visbook::Response.new(status: status, body: body)
  end
end

require_relative "../test_helper"

class PdfTest < Minitest::Test
  include VisbookTestHelpers

  def test_list_gets_pdf_by_encrypted_company_id_and_order_id
    @client.pdf.list(encrypted_company_id: "abc", order_id: 12)

    assert_request "GET", "/pdf/abc/12"
  end

  def test_stream_gets_pdf_by_encrypted_company_id_order_id_and_visdoc_id
    @connection.respond_with(body: "%PDF-1.7", headers: {"Content-Type" => ["application/pdf"]})

    response = @client.pdf.stream(encrypted_company_id: "abc", order_id: 12, visdoc_id: 55)

    assert_request "GET", "/pdf/abc/12/55"
    assert_equal "%PDF-1.7", response.raw_body
  end
end

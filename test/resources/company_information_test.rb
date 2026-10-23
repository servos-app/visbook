require_relative "../test_helper"

class CompanyInformationTest < Minitest::Test
  include VisbookTestHelpers

  def test_retrieve_gets_companyinformation
    @client.company_information.retrieve

    assert_request "GET", "/companyinformation"
  end

  def test_find_gets_companyinformation_by_id
    @client.company_information.find("abc")

    assert_request "GET", "/companyinformation/abc"
  end
end

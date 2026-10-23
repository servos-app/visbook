module Visbook
  module Resources
    # CompanyInformation — about the current company (the one bound to the
    # configured webentity), or a related company by encrypted id.
    class CompanyInformation < Resource
      # GET /api/{webentity}/companyinformation
      def retrieve
        client.get("/companyinformation")
      end

      # GET /api/{webentity}/companyinformation/{id}
      #
      # @param id [String] encrypted company identifier
      def find(id)
        client.get("/companyinformation/#{id}")
      end
    end
  end
end

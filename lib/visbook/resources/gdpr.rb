module Visbook
  module Resources
    # GDPR — kicks off a GDPR report generation request.
    class Gdpr < Resource
      # GET /api/{webentity}/gdpr
      def request_report
        client.get("/gdpr")
      end
    end
  end
end

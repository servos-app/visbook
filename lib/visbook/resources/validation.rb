module Visbook
  module Resources
    # Validation — exchange a one-time-token for an authentication cookie.
    # The cookie is captured automatically by the client and re-sent on
    # subsequent requests.
    class Validation < Resource
      # GET /api/{webentity}/validation/email/{token}
      def email(token:)
        client.get("/validation/email/#{token}")
      end

      # GET /api/{webentity}/validation/mobile/{token}
      def mobile(token:)
        client.get("/validation/mobile/#{token}")
      end
    end
  end
end

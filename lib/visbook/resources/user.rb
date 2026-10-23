module Visbook
  module Resources
    # User — authenticated guest profile. All actions require a session
    # cookie obtained from {Resources::Validation}.
    class User < Resource
      # GET /api/{webentity}/user
      def retrieve
        client.get("/user")
      end

      # PUT /api/{webentity}/user
      #
      # @param body [Hash] {ChangeUserInfoViewModel}; supports partial update.
      #   Pass `emailToken` / `mobileToken` to confirm changes to those.
      def update(body)
        client.put("/user", body: body)
      end

      # DELETE /api/{webentity}/user
      #
      # Anonymize the user across the current company and related companies.
      def anonymize
        client.delete("/user")
      end
    end
  end
end

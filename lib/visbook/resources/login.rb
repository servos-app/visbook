module Visbook
  module Resources
    # Login — request a one-time-password sent to the guest's email or
    # phone. The token returned by the user must then be passed to
    # {Resources::Validation} which sets the session cookie.
    class Login < Resource
      # POST /api/{webentity}/login/request/email
      #
      # Sends a one-time login token to the email. Body is form-encoded.
      def request_email_token(email:)
        client.post("/login/request/email", form: {email: email})
      end

      # POST /api/{webentity}/login/request/sms
      #
      # Sends a one-time login token via SMS.
      def request_sms_token(country_code:, phone_number:)
        client.post(
          "/login/request/sms",
          form: {countryCode: country_code, phoneNumber: phone_number}
        )
      end

      # POST /api/{webentity}/logout
      def logout
        response = client.post("/logout")
        client.session_cookie = nil
        response
      end
    end
  end
end

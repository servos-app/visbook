module Visbook
  module Resources
    # ReleaseChangeLog — current API version + changes per version.
    class ReleaseChangeLog < Resource
      # GET /api/{webentity}/releasechangelog
      def retrieve
        client.get("/releasechangelog")
      end
    end
  end
end

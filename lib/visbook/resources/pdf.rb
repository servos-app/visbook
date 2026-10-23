module Visbook
  module Resources
    # Pdf — order document downloads.
    #
    # The single-arg variant {#list} is deprecated upstream; prefer
    # {#stream} once you know the visdoc id (returned by the order/
    # ordergroup endpoints in `pdfs`).
    class Pdf < Resource
      # GET /api/{webentity}/pdf/{encryptedCompanyId}/{orderId}
      #
      # @deprecated upstream. Returns metadata about available pdfs.
      def list(encrypted_company_id:, order_id:)
        client.get("/pdf/#{encrypted_company_id}/#{order_id}")
      end

      # GET /api/{webentity}/pdf/{encryptedCompanyId}/{orderId}/{visdocId}
      #
      # Returns a {Response} whose `raw_body` is the binary PDF stream.
      def stream(encrypted_company_id:, order_id:, visdoc_id:)
        client.get("/pdf/#{encrypted_company_id}/#{order_id}/#{visdoc_id}")
      end
    end
  end
end

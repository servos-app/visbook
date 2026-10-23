module Visbook
  # Base class for API resources
  #
  # Visbook is RPC-flavored rather than strictly REST. Some resources are
  # singleton-like (`/company`), some are list-only (`/rooms`), and a few
  # support full CRUD (`/booking`). Subclasses opt in to whichever helpers
  # apply by overriding `#resource_path` and calling `client.{get,post,...}`
  # directly when an endpoint doesn't fit a CRUD pattern.
  #
  class Resource
    attr_reader :client

    def initialize(client)
      @client = client
    end

    # Retrieve a single resource by id (e.g. `/booking/123`).
    def retrieve(id, params: {})
      client.get("#{resource_path}/#{id}", params: params)
    end

    # List resources, optionally with query params.
    def list(params: {})
      client.get(resource_path, params: params)
    end

    # Create a new resource by POSTing the body.
    def create(body)
      client.post(resource_path, body: body)
    end

    # Update an existing resource via PUT.
    def update(id, body)
      client.put("#{resource_path}/#{id}", body: body)
    end

    # Delete a resource.
    def delete(id)
      client.delete("#{resource_path}/#{id}")
    end

    protected

    # Override in subclasses to define the API path.
    def resource_path
      raise NotImplementedError, "Subclass must implement #resource_path"
    end
  end
end

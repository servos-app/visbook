module Visbook
  module Objects
    class ChangeLog < Visbook::Object
      attribute :name
      attribute :version
      attribute :released_at
      attribute :changelog
    end

    class ReleaseChangeLog < Visbook::Object
      attribute :current_version
      array_attribute :change_logs, type: ChangeLog
    end
  end
end

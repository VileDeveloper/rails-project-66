# frozen_string_literal: true

class Git::Stub
  class << self
    def clone(_clone_url, _path_to_clone)
      true
    end
  end
end

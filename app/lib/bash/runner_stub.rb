# frozen_string_literal: true

class Bash::RunnerStub
  class << self
    def execute(_command)
      ['', 0]
    end
  end
end

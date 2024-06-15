# frozen_string_literal: true

class Bash::Runner
  class << self
    def execute(command)
      output, exit_status = Open3.popen3(command) { |_stdin, stdout, _stderr, wait_thr| [stdout.read, wait_thr.value] }

      [output, exit_status.exitstatus]
    end
  end
end

# frozen_string_literal: true

class AppContainer
  extend Dry::Container::Mixin

  if Rails.env.test?
    register :bash_runner, -> { Bash::RunnerStub }
    register :git, -> { Git::GitStub }
    register :github_client, -> { Github::ClientStub }
  else
    register :bash_runner, -> { Bash::Runner }
    register :git, -> { Git }
    register :github_client, -> { Github::Client }
  end
end

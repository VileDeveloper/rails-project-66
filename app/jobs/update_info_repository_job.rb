# frozen_string_literal: true

class UpdateInfoRepositoryJob < ApplicationJob
  queue_as :default

  def perform(repository_id)
    repository = Repository.find(repository_id)
    github_client = github_client_by(repository)

    github_client.update_repository_info!
    github_client.create_hook
  end

  private

  def github_client_by(repository)
    github_client = AppContainer[:github_client]
    github_client.new(repository:)
  end
end

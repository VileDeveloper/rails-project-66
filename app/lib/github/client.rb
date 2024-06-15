# frozen_string_literal: true

class Github::Client
  attr_reader :current_repository, :user, :client

  def initialize(repository:, user: nil)
    @current_repository = repository
    @user = user || @current_repository.user
    @client = Octokit::Client.new(access_token: @user.token, auto_paginate: true)
  end

  def repos
    @client.repos
  end

  def repos_collection
    repos = repos_with_valid_lang(client.repos, user)
    repos.map! { |rep| [rep[:full_name], rep[:id]] }
    repos.each { |rep| ::Repository.create(github_id: rep[1], full_name: rep[0]) }
    repos
  end

  def get_latest_commit_sha(rep_full_name)
    @client.commits(rep_full_name).first.sha
  end

  def update_repository_info!
    repository_atttributes = repository_params

    current_repository.assign_attributes(repository_atttributes)

    current_repository.save!
  end

  def create_hook
    @client.create_hook(
      @current_repository.full_name,
      'web',
      { url: "#{ENV.fetch('BASE_URL', nil)}/api/checks", content_type: 'json' },
      { events: %w[push], active: true }
    )
  end

  def clone_repository(repository, dir_path)
    system("git clone #{repository.clone_url} #{dir_path}")
  end

  def find_instance_repository(github_id)
    repos.find { |rep| rep[:id] == github_id&.to_i }
  end

  def repository_params
    github_repo_id = current_repository.github_id
    repository_data = user_repositories.find { |repo| repo[:id] == github_repo_id.to_i }

    {
      name: repository_data[:name],
      full_name: repository_data[:full_name],
      language: repository_data[:language].downcase,
      clone_url: repository_data[:clone_url],
      ssh_url: repository_data[:ssh_url]
    }
  end

  private

  def user_repositories
    @client.repos
  end

  def repos_with_valid_lang(repos, user)
    repos.filter do |rep|
      next false unless rep[:language]

      language = rep[:language].downcase
      repo = user.repositories.new(language:)
      repo.github_id = rep[:id]
      repo.valid?
    end
  end
end

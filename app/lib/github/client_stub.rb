# frozen_string_literal: true

class Github::ClientStub
  attr_reader :current_repository, :user, :client

  REPOSITORY = {
    id: 123_456_789,
    ssh_url: 'git@github.com:VileDevelper/ruby_project.git',
    name: 'ruby_project',
    full_name: 'VileDevelper/ruby_project',
    language: 'ruby',
    clone_url: 'https://github.com/VileDevelper/ruby_project.git'
  }.freeze

  REPOS_COLLECTION = [
    { github_id: 123_456_789 },
    { github_id: 987_654_321 },
    { github_id: 112_233_445 },
    { github_id: 556_677_889 }
  ].freeze

  def initialize(repository:, user: nil)
    @current_repository = repository
    @user = user || @current_repository.user
    @client = Octokit::Client.new(access_token: @user.token, auto_paginate: true)
  end

  def repos
    [REPOSITORY]
  end

  def get_latest_commit_sha(_rep_full_name)
    'random_commit_hash'
  end

  def clone_repository(_repository, dir_path)
    FileUtils.mkdir_p(dir_path)
  end

  def find_instance_repository(github_id)
    Repository.find_by(github_id: github_id&.to_i)
  end

  def repos_collection
    REPOS_COLLECTION
  end

  def update_repository_info!
    repository_atttributes = repository_params

    current_repository.assign_attributes(repository_atttributes)

    current_repository.save!
  end

  def create_hook
    true
  end

  def repository_params
    {
      name: 'javascript_project',
      full_name: 'VileDeveloper/javascript_project',
      language: 'javascript',
      clone_url: 'https://github.git/VileDeveloper/javascript_project',
      ssh_url: 'github.git/VileDeveloper/javascript_project'
    }
  end
end

# frozen_string_literal: true

module Web
  class RepositoriesController < Web::ApplicationController
    before_action :set_repository, only: [:show]
    before_action :set_github_client

    def index
      @repositories = current_user.repositories.page(params[:page])
    end

    def show
      authorize @repository

      @checks = @repository.checks.order(id: :desc).page(params[:page])
    end

    def new
      @repository = current_user.repositories.build

      authorize @repository

      @repositories = fetch_github_repositories
    end

    def create
      @repository = current_user.repositories.find_or_initialize_by(repository_params)

      authorize @repository

      if @repository.save
        UpdateInfoRepositoryJob.perform_later(@repository.id)
        redirect_to repositories_path, notice: t('.success')
      else
        flash[:alert] = @repository.errors.full_messages.join('\n')
        redirect_to action: :new
      end
    end

    private

    def repository_params
      params.require(:repository).permit(:github_id)
    end

    def set_repository
      @repository = ::Repository.find(params[:id])
    end

    def set_github_client
      @github_client = AppContainer[:github_client].new(repository: @repository, user: current_user)
    end

    def fetch_github_repositories
      cache_key = "#{current_user.cache_key_with_version}/github_repositories"
      Rails.cache.fetch(cache_key, expires_in: 12.hours) do
        @github_client.repos_collection
      end
    end
  end
end

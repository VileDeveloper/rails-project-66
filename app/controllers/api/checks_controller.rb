# frozen_string_literal: true

class Api::ChecksController < Api::ApplicationController
  def create
    full_name = params[:repository][:full_name]
    repository = Repository.find_by(full_name:)

    unless repository
      head :not_found
      return
    end

    check = repository.checks.create!

    CheckRepositoryJob.perform_later(check.id)

    head :ok
  end
end

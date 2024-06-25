# frozen_string_literal: true

module Web
  module Repositories
    class ChecksController < Web::Repositories::ApplicationController
      def show
        @check = ::Repository::Check.includes(:repository).find(params[:id])

        authorize @check

        if !@check.finished? && !@check.failed?
          flash[:notice] = t('.check_in_progress')
          redirect_to @check.repository and return
        end

        parsed_check_details = JSON.parse(@check.details.presence || '{}')
        @check_result = LogFormatter.format(parsed_check_details, @check.repository.language)
      end

      def create
        @repository = ::Repository.find(params[:repository_id])
        check = @repository.checks.create!

        authorize check

        CheckRepositoryJob.perform_later(check.id)

        flash[:notice] = t('.success')
        redirect_to @repository
      end
    end
  end
end

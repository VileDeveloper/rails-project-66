# frozen_string_literal: true

module Web
  module Repositories
    class ChecksController < Web::Repositories::ApplicationController
      before_action :set_check, only: :show
      before_action :set_repository, only: :create

      def show
        authorize @check

        if !@check.finished? && !@check.failed?
          flash[:notice] = t('.check_in_progress')
          redirect_to @check.repository and return
        end

        parsed_check_details = JSON.parse(@check.details.presence || '{}')
        @check_result = LogFormatter.format(parsed_check_details, @check.repository.language)
      end

      def create
        check = @repository.checks.create!
        authorize check

        CheckRepositoryJob.perform_later(check.id)

        flash[:notice] = t('.success')
        redirect_to @repository
      end

      private

      def set_check
        @check = ::Repository::Check.includes(:repository).find(params[:id])
      end

      def set_repository
        @repository = ::Repository.find(params[:repository_id])
      end
    end
  end
end

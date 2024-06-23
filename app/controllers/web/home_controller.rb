# frozen_string_literal: true

module Web
  class HomeController < Web::ApplicationController
    skip_before_action :authenticate_user!, only: [:index]

    def index; end
  end
end

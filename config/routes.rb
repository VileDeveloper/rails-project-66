# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: :web do
    root 'home#index'

    get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth
    post 'auth/:provider', to: 'auth#request', as: :auth_request

    delete 'auth/logout'

    resources :repositories, only: %i[index show new create update] do
      scope module: :repositories do
        resources :checks, only: %i[create show]
      end
    end
  end

  namespace :api do
    resources :checks, only: %i[create]
  end
end

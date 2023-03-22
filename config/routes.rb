# frozen_string_literal: true

Rails.application.routes.draw do
  post '/authenticate', to: 'sessions#create'

  namespace :v1 do
    resources :blobs, only: %i[create show]
  end
end

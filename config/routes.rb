# frozen_string_literal: true

Rails.application.routes.draw do
  post '/authenticate', to: 'sessions#create'
end

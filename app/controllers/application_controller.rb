# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :authenticate_token

  attr_reader :current_user

  private

  def authenticate_token
    user_id = TokenService::Authenticate.new.call(request)
    @current_user = User.find(user_id)
  rescue JWT::DecodeError
    render json: { error: 'invalid token' }, status: :unprocessable_entity
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
end

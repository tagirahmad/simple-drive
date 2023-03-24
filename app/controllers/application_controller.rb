# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :authenticate_token

  attr_reader :current_user

  private

  def authenticate_token
    authenticate_or_request_with_http_token do |token, _options|
      user_id = Token::Authenticate.new.call(token)
      @current_user = User.find(user_id)
    end
  rescue JWT::DecodeError
    render json: { error: 'invalid token' }, status: :unprocessable_entity
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
end

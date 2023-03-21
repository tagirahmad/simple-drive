class ApplicationController < ActionController::API
  before_action :authenticate_token

  private

  def authenticate_token
    auth_header = request.headers['Authorization']
    token = auth_header.split(' ').last if auth_header
    begin
      decoded_token = JWT.decode(token, Rails.application.secrets.secret_key_base)
      user_id = decoded_token[0]['user_id']
      @user = User.find(user_id)
    rescue JWT::DecodeError
      render json: { error: 'Invalid token' }, status: :unprocessable_entity
    end
  end
end

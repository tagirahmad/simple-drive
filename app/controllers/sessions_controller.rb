class SessionsController < ApplicationController
  skip_before_action :authenticate_token

  def create
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      token = encode_token(user_id: user.id)
      render json: { token: }
    else
      render json: { error: 'invalid email or password' }, status: :unprocessable_entity
    end
  end

  private

  def encode_token(payload)
    JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end
end

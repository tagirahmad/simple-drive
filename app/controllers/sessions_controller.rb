# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :authenticate_token

  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      token = TokenService::Encode.new.call(user_id: user.id)
      render json: { token: }
    else
      render json: { error: 'invalid email or password' }, status: :unprocessable_entity
    end
  end
end

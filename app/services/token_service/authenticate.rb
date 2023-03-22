# frozen_string_literal: true

module TokenService
  class Authenticate
    def call(request)
      auth_header = request.headers['Authorization']
      token = auth_header.split(' ').last

      raise StandardError, 'Authorization header is not provided' unless auth_header
      raise StandardError, 'token is not provided' unless token.is_a?(String)

      decoded_token = JWT.decode(token, Rails.application.secrets.secret_key_base)
      decoded_token.first['user_id']
    end
  end
end

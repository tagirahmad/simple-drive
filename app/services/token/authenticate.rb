# frozen_string_literal: true

module Token
  class Authenticate
    def call(token)
      raise StandardError, 'token is not provided' unless token.is_a?(String)

      decoded_token = JWT.decode(token, Rails.application.secrets.secret_key_base)
      decoded_token.first['user_id']
    end
  end
end

# frozen_string_literal: true

module Token
  class Encode
    def call(payload)
      JWT.encode(payload, Rails.application.secrets.secret_key_base)
    end
  end
end

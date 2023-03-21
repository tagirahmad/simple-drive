# frozen_string_literal: true

class User < ApplicationRecord
  has_many_attached :blobs
  has_secure_password
end

# frozen_string_literal: true

module BlobService
  class Base64Error < Error
    def initialize(msg = 'invalid 64')
      super(msg)
    end
  end
end

# frozen_string_literal: true

module BlobService
  class IdError < Error
    def initialize(msg = 'Invalid id provided')
      super(msg)
    end
  end
end

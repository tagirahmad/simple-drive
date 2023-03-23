# frozen_string_literal: true

module BlobService
  class ParamKeyError < Error
    def initialize(msg = nil)
      super(msg)
    end
  end
end

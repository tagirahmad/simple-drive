# frozen_string_literal: true

module Blob
  class Error < StandardError; end

  class Base64Error < Error
    def initialize(msg = 'invalid 64')
      super(msg)
    end
  end

  class IdError < Error
    def initialize(msg = 'invalid id provided')
      super(msg)
    end
  end

  class ParamKeyError < Error
    def initialize(msg = nil)
      super(msg)
    end
  end
end

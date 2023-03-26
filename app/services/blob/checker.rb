# frozen_string_literal: true

module Blob
  module Checker
    def self.call(id, data)
      Id.new.call(id)
      BinData.new.call(data)
    end
  end
end

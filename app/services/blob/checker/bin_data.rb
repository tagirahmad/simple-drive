# frozen_string_literal: true

module Blob
  module Checker
    class BinData
      def call(data)
        ::Base64.strict_decode64(data).is_a?(String)
      rescue ArgumentError => e
        raise Blob::Base64Error, e.message
      end
    end
  end
end

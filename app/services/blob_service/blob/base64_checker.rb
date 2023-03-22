# frozen_string_literal: true

module BlobService
  module Blob
    class Base64Checker
      def call(data)
        Base64.strict_decode64(data).is_a?(String)
      rescue ArgumentError => e
        raise BlobService::Base64Error, e.message
      end
    end
  end
end

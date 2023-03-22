# frozen_string_literal: true

module BlobService
  module Blob
    class IdChecker
      def call(id)
        raise BlobService::IdError, 'id must be only positive integer' if id.to_i.zero?

        true
      end
    end
  end
end

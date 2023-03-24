# frozen_string_literal: true

module Blob
  module Checker
    class Id
      def call(id)
        raise Blob::IdError, 'id must be provided' if id.nil?
        raise Blob::IdError, 'id must be only positive integer' if id.to_i.zero?

        true
      end
    end
  end
end

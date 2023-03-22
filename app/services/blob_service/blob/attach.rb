# frozen_string_literal: true

module BlobService
  module Blob
    class Attach
      def call(blob, user)
        user.blobs.attach(blob)
      end
    end
  end
end

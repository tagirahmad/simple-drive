# frozen_string_literal: true

module Blob
  module ActiveStorage
    module Uploader
      class Attach
        def call(blob, user)
          user.blobs.attach(blob)
        end
      end
    end
  end
end

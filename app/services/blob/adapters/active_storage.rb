# frozen_string_literal: true

module Blob
  module Adapters
    module ActiveStorage
      module Uploader
        def self.call(id, data, **options)
          Blob::ActiveStorage::Uploader.call(id, data, **options)
        end
      end
    end
  end
end

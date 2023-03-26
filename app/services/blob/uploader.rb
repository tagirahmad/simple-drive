# frozen_string_literal: true

module Blob
  module Uploader
    DEFAULT_STORAGE = :local

    def self.call(id, data, **options)
      if options[:adapter].nil?
        Blob::Adapters::ActiveStorage::Uploader.call(id, data, **options) # By default, ActiveStorage adapter is used
      else
        options[:adapter].call(id, data, **options)
      end
    end
  end
end

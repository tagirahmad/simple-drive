# frozen_string_literal: true

module BlobService
  module Blob
    DEFAULT_STORAGE = :local

    def self.create(id, data, **options)
      raise ActiveRecord::RecordNotUnique if ActiveStorage::Blob.exists?(id)

      blob = Prepare.new.call(id, data, **options)

      Attach.new.call(blob, options[:user])

      blob
    end
  end
end

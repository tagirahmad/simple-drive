# frozen_string_literal: true

module Blob
  module Uploader
    DEFAULT_STORAGE = :local

    def self.call(id, data, **options)
      raise ActiveRecord::RecordNotUnique if ActiveStorage::Blob.exists?(id)

      blob = Prepare.new.call(id, data, **options)

      Attach.new.call(blob, options[:user])

      blob
    end
  end
end

# frozen_string_literal: true

module Blob
  module Uploader
    class Prepare
      def call(id, data, **options)
        validate_and_prepare(id, data, **options)
      end

      private

      def validate_and_prepare(id, data, **options)
        Blob::Checker.call(id, data)

        blob = ActiveStorage::Blob.new(id:, filename: "file_#{id}", service_name: options[:storage] || DEFAULT_STORAGE)
        blob.upload(StringIO.new(::Base64.strict_decode64(data)))

        blob
      rescue KeyError => e
        raise Blob::ParamKeyError, e.message
      end
    end
  end
end

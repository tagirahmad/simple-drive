# frozen_string_literal: true

class BlobResource < BaseSerializer
  attribute(:id) { _1.id.to_s }
  attribute(:data) { Base64.strict_encode64(_1.download) }
  attribute(:size, &:byte_size)
  attribute(:created_at) { _1.created_at.iso8601 }
end

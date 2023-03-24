# frozen_string_literal: true

require 'rails_helper'

describe Blob::Uploader::Prepare do
  describe '#call' do
    it 'instantiates ActiveStorage::Blob with specified parameters' do
      service = described_class.new

      expect(service.call(1, 'SGVsbG8gU2ltcGxlIFN0b3JhZ2UgV29ybGQh', storage: :local))
        .to be_an_instance_of(ActiveStorage::Blob)
        .and(have_attributes(id: 1, service_name: 'local'))
    end
  end
end

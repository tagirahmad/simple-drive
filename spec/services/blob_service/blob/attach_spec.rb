# frozen_string_literal: true

require 'rails_helper'

describe BlobService::Blob::Attach do
  describe '#call' do
    let(:user)    { User.create!(email: 'test@gmail.com', password: 'testqwerty') }
    let(:service) { described_class.new }

    it 'attaches blob' do
      blob = BlobService::Blob::Prepare.new.call(1, 'SGVsbG8gU2ltcGxlIFN0b3JhZ2UgV29ybGQh', storage: :local)

      expect { service.call(blob, user) }.to change(ActiveStorage::Blob, :count).by 1
    end
  end
end

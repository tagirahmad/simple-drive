# frozen_string_literal: true

require 'rails_helper'

describe BlobService::Blob do
  describe '.create' do
    let(:service) { described_class }
    let(:user) { User.first_or_create!(email: 'test@gmail.com', password: 'testqwerty') }

    it 'creates blobs' do
      expect { service.create(1, 'SGkgYWdhaW4=', user:, service: :local) }
        .to change(ActiveStorage::Blob, :count).by 1
    end

    it 'creates blobs' do
      expect { service.create(1, 'SGkgYWdhaW4=', user:, service: :local) }
        .to change(ActiveStorage::Blob, :count).by 1
    end

    it 'raises ActiveRecord::RecordNotUnique exception if blob_service already exists' do
      service.create(1, 'SGkgYWdhaW4=', user:, service: :local)

      expect { service.create(1, 'SGkgYWdhaW4=', user:, service: :local) }
        .to raise_exception ActiveRecord::RecordNotUnique
    end
  end
end

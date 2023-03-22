# frozen_string_literal: true

require 'rails_helper'

describe V1::BlobsController, type: :request do
  let(:user)  { User.create!(email: 'test@gmail.com', password: 'testqwerty') }
  let(:token) { TokenService::Encode.new.call(user_id: user.id) }
  let(:headers_with_token) { { headers: { 'Authorization': "Bearer #{token}" } } }

  describe '#create /blobs' do
    context 'when valid JSON body' do
      describe 'with valid storage query parameter provided' do
        let(:valid_params_with_storage) do
          { params: { id: 1, data: 'SGkgYWdhaW4=', storage: :local },
            **headers_with_token }
        end
        it 'successfully creates and saves new blob to specified storage' do
          expect { post v1_blobs_path, **valid_params_with_storage }.to change(ActiveStorage::Blob, :count).by 1
        end

        it 'responses with the blob' do
          post v1_blobs_path, **valid_params_with_storage

          expect(response.body).to include 'id', 'data', 'size', 'created_at'
        end
      end

      describe 'without storage query parameter provided' do
        it 'successfully creates and saves new blob to local storage by default' do
          expect { post v1_blobs_path, params: { id: 1, data: 'SGkgYWdhaW4=' }, **headers_with_token }
            .to change(ActiveStorage::Blob, :count).by 1
        end
      end

      describe 'with invalid storage query parameter provided' do
        it 'does not create and save new blob to storage and responses with 400 status code' do
          params_with_invalid_storage = { params: { storage: :invalid, id: 1, data: 'SGkgYWdhaW4=' },
                                          **headers_with_token }

          post v1_blobs_path, **params_with_invalid_storage

          expect(response).to have_http_status :bad_request
          expect { post v1_blobs_path, **params_with_invalid_storage }.to change(ActiveStorage::Blob, :count).by 0
        end
      end
    end

    context 'when invalid JSON body provided' do
      it 'responses with 400 status code' do
        post v1_blobs_path, params: { id: 1, data: 'invalid' }, **headers_with_token

        expect(response).to have_http_status :bad_request
        expect(response.body).to include 'invalid base64'
      end
    end
  end

  describe '#show /blobs/:id' do
    describe 'with valid params' do
      context 'if record exists' do
        it 'successfully retrieves a blob' do
          blob = BlobService::Blob.create(1, 'SGkgYWdhaW4=', user:, storage: :local)

          get v1_blob_path(blob), **headers_with_token

          expect(response).to have_http_status :ok
          expect(JSON.parse(response.body).keys).to include 'id', 'data', 'size', 'created_at'
        end
      end

      context 'if record does not exist' do
        it 'returns 404 status code' do
          blob = BlobService::Blob::Prepare.new.call(1, 'SGkgYWdhaW4=', user:, storage: :local)

          get v1_blob_path(blob), **headers_with_token

          expect(response).to have_http_status :not_found
        end
      end
    end

    describe 'with invalid params' do
      it 'returns 400 status code' do
        get '/v1/blobs/invalid_id', **headers_with_token

        expect(response).to have_http_status :bad_request
      end
    end
  end
end

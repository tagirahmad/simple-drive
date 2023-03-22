# frozen_string_literal: true

module V1
  class BlobsController < ApplicationController
    def create
      id   = params[:id]
      data = params[:data]

      blob = BlobService::Blob.create(id, data, user: current_user, storage: params[:storage])

      render json: success_response(blob)
    rescue ActiveRecord::RecordNotUnique
      render json: { error: "Record with ID=#{id} already exists" }, status: :conflict
    rescue BlobService::IdError, BlobService::Base64Error, BlobService::ParamKeyError => e
      render json: { error: e.message }, status: :bad_request
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    def show
      BlobService::Blob::IdChecker.new.call(params[:id])

      blob = find_blob(params[:id])

      render json: success_response(blob)
    rescue ActiveStorage::FileNotFoundError, ActiveRecord::RecordNotFound
      render json: { error: 'Not Found' }, status: :not_found
    rescue BlobService::IdError => e
      render json: { error: e.message }, status: :bad_request
    rescue StandardError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end

    private

    def find_blob(id)
      current_user.blobs.blobs.find(id)
    end

    def success_response(blob)
      {
        id: blob.id,
        data: Base64.strict_encode64(blob.download),
        size: blob.byte_size,
        created_at: blob.created_at
      }
    end
  end
end

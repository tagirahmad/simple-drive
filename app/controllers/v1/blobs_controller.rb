# frozen_string_literal: true

module V1
  class BlobsController < ApplicationController
    before_action :check_id, only: :show

    rescue_from ActiveRecord::RecordNotUnique, with: :record_already_exists

    def create
      id   = params[:id]
      data = params[:data]

      blob = Blob::Uploader.call(id, data, user: current_user, storage: params[:storage])

      render json: success_response(blob)
    rescue ActiveRecord::RecordNotUnique
      render json: { error: "Record with ID=#{id} already exists" }, status: :conflict
    rescue Blob::IdError, Blob::Base64Error, Blob::ParamKeyError => e
      render json: { error: e.message }, status: :bad_request
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    def show
      blob = find_blob(params[:id])

      render json: success_response(blob)
    rescue ActiveStorage::FileNotFoundError, ActiveRecord::RecordNotFound
      render json: { error: 'not Found' }, status: :not_found
    rescue StandardError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end

    private

    def find_blob(id)
      current_user.blobs.blobs.find(id)
    end

    def check_id
      Blob::Checker::Id.new.call(params[:id])
    rescue Blob::IdError => e
      render json: { error: e.message }, status: :bad_request
    end

    def success_response(blob)
      # usually it's better to use serializers or, at least .as_json,
      # but in our case it's not so good to produce lots of entities
      {
        id: blob.id,
        data: Base64.strict_encode64(blob.download),
        size: blob.byte_size,
        created_at: blob.created_at
      }
    end
  end
end

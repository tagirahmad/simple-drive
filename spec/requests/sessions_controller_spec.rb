# frozen_string_literal: true

require 'rails_helper'

describe SessionsController, type: :request do
  describe '#create /authenticate' do
    context 'when user exists' do
      before { User.create!(email: 'test@gmail.com', password: 'testqwerty') }

      context 'and when correct credentials are passed' do
        it 'responses with auth token' do
          post '/authenticate', params: { "email": 'test@gmail.com', "password": 'testqwerty' }

          expect(JSON.parse(response.body).key?('token')).to eq true
        end
      end

      context 'and when incorrect credentials are passed' do
        it 'responses with error and 422 status code' do
          post '/authenticate', params: { "email": 'test@gmail.com', "password": 'wrong_pass' }

          expect(response.body).to include 'invalid email or password'
          expect(response).to have_http_status :unprocessable_entity
        end
      end
    end

    context 'when user does not exist' do
      it 'responses with error and 422 status code' do
        post '/authenticate', params: { "email": 'unexistent@gmail.com', "password": 'password' }

        expect(response.body).to include 'invalid email or password'
        expect(response).to have_http_status :unprocessable_entity
      end
    end
  end
end

# spec/requests/users_spec.rb
require 'swagger_helper'

RSpec.describe 'Users API', type: :request do
  path '/users' do
    post 'Creates a user' do
      tags 'Users'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          username: { type: :string },
          name: { type: :string },
          password: { type: :string }
        },
        required: %w[email username password]
      }

      response '201', 'user created' do
        let(:user) { { email: 'test@example.com', username: 'testuser', password: 'password123' } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to have_key('token')
          expect(data['user']).to include('email', 'username')
        end
      end

      response '422', 'invalid request' do
        let(:user) { { email: 'invalid' } }
        run_test!
      end
    end
  end

  path '/me' do
    get 'Retrieves current user' do
      tags 'Users'
      security [bearer_auth: []]
      produces 'application/json'

      response '200', 'current user retrieved' do
        let(:user) { create(:user) }
        let(:Authorization) { "Bearer #{generate_jwt_token(user)}" }

        run_test! do |response|
          expect(response).to have_http_status(:ok)
        end
      end

      response '401', 'unauthorized' do
        let(:Authorization) { 'Bearer invalid' }
        run_test!
      end
    end
  end

  path '/users/{id}/bets' do
    get 'Retrieves user bets' do
      tags 'Users'
      security [bearer_auth: []]
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      response '200', 'bets retrieved' do
        let(:user) { create(:user) }
        let(:id) { user.id }
        let(:Authorization) { "Bearer #{generate_jwt_token(user)}" }

        run_test! do |response|
          expect(response).to have_http_status(:ok)
        end
      end
    end
  end

  path '/users/fund-user-dummy' do
    post 'Funds user account (dummy)' do
      tags 'Users'
      security [bearer_auth: []]

      response '200', 'user funded' do
        let(:user) { create(:user, balance: 0) }
        let(:Authorization) { "Bearer #{generate_jwt_token(user)}" }

        run_test! do |response|
          expect(user.reload.balance).to eq(500)
        end
      end
    end
  end
end
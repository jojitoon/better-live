# spec/requests/auth_spec.rb
require 'swagger_helper'

RSpec.describe 'Auth API', type: :request do
  path '/login' do
    post 'Authenticates user' do
      tags 'Authentication'
      consumes 'application/json'
      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string }
        },
        required: %w[email password]
      }

      response '200', 'user authenticated' do
        let(:user) { create(:user, password: 'password123') }
        let(:credentials) { { email: user.email, password: 'password123' } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to have_key('token')
        end
      end

      response '401', 'unauthorized' do
        let(:credentials) { { email: 'wrong@email.com', password: 'wrong' } }
        run_test!
      end
    end
  end
end
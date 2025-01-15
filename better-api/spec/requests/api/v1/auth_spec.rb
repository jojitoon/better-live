require 'swagger_helper'

RSpec.describe 'Authentication API', type: :request do
  path '/api/v1/users/sign_in' do
    post 'Signs in a user' do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'
      
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string },
              password: { type: :string }
            },
            required: ['email', 'password']
          }
        }
      }

      response '200', 'user signed in' do
        schema type: :object,
          properties: {
            status: {
              type: :object,
              properties: {
                code: { type: :integer },
                message: { type: :string }
              }
            },
            data: { '$ref' => '#/components/schemas/user' }
          }
        
        let(:user) { { user: { email: 'test@example.com', password: 'password123' } } }
        run_test!
      end

      response '401', 'invalid credentials' do
        schema '$ref' => '#/components/schemas/error'
        let(:user) { { user: { email: 'wrong@example.com', password: 'wrongpass' } } }
        run_test!
      end
    end
  end

  path '/api/v1/users/sign_up' do
    post 'Registers a new user' do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'
      
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string },
              password: { type: :string },
              password_confirmation: { type: :string },
              name: { type: :string },
              username: { type: :string }
            },
            required: ['email', 'password', 'password_confirmation', 'name', 'username']
          }
        }
      }

      response '200', 'user created' do
        schema type: :object,
          properties: {
            status: {
              type: :object,
              properties: {
                code: { type: :integer },
                message: { type: :string }
              }
            },
            data: { '$ref' => '#/components/schemas/user' }
          }
        
        let(:user) do
          {
            user: {
              email: 'test@example.com',
              password: 'password123',
              password_confirmation: 'password123',
              name: 'Test User',
              username: 'testuser'
            }
          }
        end
        run_test!
      end

      response '422', 'invalid request' do
        schema '$ref' => '#/components/schemas/error'
        let(:user) { { user: { email: 'invalid' } } }
        run_test!
      end
    end
  end

  path '/api/v1/users/sign_out' do
    delete 'Signs out a user' do
      tags 'Authentication'
      security [bearer_auth: []]
      produces 'application/json'

      response '200', 'user signed out' do
        schema type: :object,
          properties: {
            status: { type: :integer },
            message: { type: :string }
          }
        
        let(:Authorization) { 'Bearer token' }
        run_test!
      end

      response '401', 'unauthorized' do
        schema '$ref' => '#/components/schemas/error'
        run_test!
      end
    end
  end
end

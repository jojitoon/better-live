require 'swagger_helper'

RSpec.describe 'Users API', type: :request do
  path '/api/v1/users/me' do
    get 'Retrieves the current user profile' do
      tags 'Users'
      security [bearer_auth: []]
      produces 'application/json'

      response '200', 'user profile retrieved' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            email: { type: :string },
            name: { type: :string },
            username: { type: :string }
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

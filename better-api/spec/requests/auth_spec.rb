require 'swagger_helper'

RSpec.describe 'auth', type: :request do

  path '/login' do

    post('login auth') do
      tags 'auth'
      response(200, 'successful') do

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end
end

# spec/requests/games_spec.rb
require 'swagger_helper'

RSpec.describe 'Games API', type: :request do
  path '/games' do
    get 'Lists all active games' do
      tags 'Games'
      produces 'application/json'

      response '200', 'games found' do
        before do
          create_list(:game, 3)
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to be_an(Array)
        end
      end
    end
  end
end
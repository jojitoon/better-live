# spec/requests/bets_spec.rb
require 'swagger_helper'

RSpec.describe 'Bets API', type: :request do
  path '/bets' do
    post 'Creates a bet' do
      tags 'Bets'
      security [bearer_auth: []]
      consumes 'application/json'
      parameter name: :bet, in: :body, schema: {
        type: :object,
        properties: {
          game_id: { type: :string },
          amount: { type: :number },
          bet_type: { type: :string },
          pick: { type: :string },
          odds: { type: :number }
        },
        required: %w[game_id amount pick odds]
      }

      response '201', 'bet created' do
        let(:user) { create(:user, balance: 1000) }
        let(:game) { create(:game) }
        let(:Authorization) { "Bearer #{generate_jwt_token(user)}" }
        let(:bet) { { game_id: game.id, amount: 100, pick: 'home_team', odds: 1.5 } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to include('id', 'amount', 'pick', 'odds')
          expect(user.reload.balance).to eq(900)
        end
      end

      response '422', 'insufficient balance' do
        let(:user) { create(:user, balance: 50) }
        let(:game) { create(:game) }
        let(:Authorization) { "Bearer #{generate_jwt_token(user)}" }
        let(:bet) { { game_id: game.id, amount: 100, pick: 'home_team', odds: 1.5 } }

        run_test! do |response|
          expect(response.body).to include('Insufficient balance')
        end
      end

      response '422', 'game closed' do
        let(:user) { create(:user, balance: 1000) }
        let(:game) { create(:game, status: 'closed') }
        let(:Authorization) { "Bearer #{generate_jwt_token(user)}" }
        let(:bet) { { game_id: game.id, amount: 100, pick: 'home_team', odds: 1.5 } }

        run_test! do |response|
          expect(response.body).to include('Game is closed for betting')
        end
      end
    end
  end

  path '/leaderboard' do
    get 'Retrieves betting leaderboard' do
      tags 'Bets'
      produces 'application/json'

      response '200', 'leaderboard retrieved' do
        before do
          allow(Bet).to receive(:leaderboard).and_return([
            { name: 'User1', total_winnings: 1000 },
            { name: 'User2', total_winnings: 500 }
          ])
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to be_an(Array)
          expect(data.first).to include('name', 'total_winnings')
        end
      end
    end
  end
end
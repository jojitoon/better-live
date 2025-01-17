require 'rails_helper'

RSpec.describe Game, type: :model do
  it { should have_many(:events) }
  it { should have_many(:bets) }
  it { should have_many(:users).through(:bets) }

  it { should validate_presence_of(:home_team) }
  it { should validate_presence_of(:away_team) }

  describe '#closed?' do
    it 'returns true if the game is closed' do
      game = Game.new(time_elapsed: 91 * 60)
      expect(game.closed?).to be true
    end

    it 'returns false if the game is not closed' do
      game = Game.new(time_elapsed: 30 * 60)
      expect(game.closed?).to be false
    end
  end

  describe '.active_games' do
    it 'returns games with time_elapsed less than or equal to 90 minutes' do
      active_game = Game.create!(home_team: 'Team A', away_team: 'Team B', time_elapsed: 30 * 60)
      inactive_game = Game.create!(home_team: 'Team C', away_team: 'Team D', time_elapsed: 91 * 60)
      expect(Game.active_games).to include(active_game)
      expect(Game.active_games).not_to include(inactive_game)
    end
  end
end

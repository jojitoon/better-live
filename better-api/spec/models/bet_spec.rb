# spec/models/bet_spec.rb
require 'rails_helper'

RSpec.describe Bet, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:game) }
  end

  describe 'validations' do
    it { should validate_numericality_of(:amount).is_greater_than(0) }
    it { should validate_numericality_of(:odds).is_greater_than(0) }
    it { should validate_presence_of(:pick) }
  end

  describe '#game_must_be_open' do
    let(:user) { create(:user) }
    let(:game) { create(:game) }
    let(:bet) { build(:bet, user: user, game: game) }

    context 'when game is open' do
      before { allow(game).to receive(:closed?).and_return(false) }

      it 'is valid' do
        expect(bet).to be_valid
      end
    end

    context 'when game is closed' do
      before { allow(game).to receive(:closed?).and_return(true) }

      it 'is invalid' do
        expect(bet).not_to be_valid
        expect(bet.errors[:game]).to include('is closed for betting')
      end
    end
  end

  describe '.leaderboard' do
    let(:redis) { instance_double(Redis) }
    before { allow($redis).to receive(:get).and_return(nil) }

    context 'when cache is empty or no_cache is true' do
      let!(:user1) { create(:user, username: 'user1') }
      let!(:user2) { create(:user, username: 'user2') }
      
      before do
        create(:bet, user: user1, amount: 100)
        create(:bet, user: user1, amount: 200)
        create(:bet, user: user2, amount: 150)
      end

      it 'returns calculated leaderboard' do
        allow($redis).to receive(:set)
        
        leaderboard = Bet.leaderboard(true)
        
        expect(leaderboard).to be_an(Array)
        expect(leaderboard.first[:name]).to eq('user1')
        expect(leaderboard.first[:total_winnings].to_f).to eq(300.0)
      end

      it 'caches the result' do
        expect($redis).to receive(:set).with('leaderboard', anything, ex: 60)
        Bet.leaderboard
      end
    end

    context 'when cache exists and no_cache is false' do
      let(:cached_leaderboard) { [{ name: 'cached_user', total_winnings: '500', id: '1' }].to_json }
      
      before do
        allow($redis).to receive(:get).with('leaderboard').and_return(cached_leaderboard)
      end

      it 'returns cached leaderboard' do
        leaderboard = Bet.leaderboard
        expect(leaderboard.first['name']).to eq('cached_user')
        expect(leaderboard.first['total_winnings']).to eq('500')
      end
    end
  end
end
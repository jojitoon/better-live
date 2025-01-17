require 'rails_helper'

RSpec.describe UpdateLeaderboardJob, type: :job do
  describe '#perform' do
    it 'calls Bet.leaderboard and publishes to Redis' do
      leaderboard_data = double('leaderboard_data')
      expect(Bet).to receive(:leaderboard).with(true).and_return(leaderboard_data)
      expect($redis).to receive(:publish).with('leaderboard', leaderboard_data.to_json)

      UpdateLeaderboardJob.new.perform
    end
  end
end

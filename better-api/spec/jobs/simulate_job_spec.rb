require 'rails_helper'

RSpec.describe SimulateJob, type: :job do
  describe '#perform' do
    it 'calls Game.refresh_games and outputs a message' do
      expect(Game).to receive(:refresh_games)
      expect { SimulateJob.new.perform }.to output("refreshed games\n").to_stdout
    end
  end
end

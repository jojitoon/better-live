require 'sidekiq-scheduler'

class SimulateJob
  include Sidekiq::Job

  def perform
    Game.refresh_games
    puts "refreshed games"
  end
end

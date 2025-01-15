class UpdateLeaderboardJob < ApplicationJob
  queue_as :default

  def perform
    leaderboard = Bet.leaderboard
    $redis.publish('leaderboard', leaderboard.to_json)
  end
end

class UpdateLeaderboardJob
  include Sidekiq::Job

  def perform(*args)
    leaderboard = Bet.leaderboard(true)
    $redis.publish('leaderboard', leaderboard.to_json)
  end
end

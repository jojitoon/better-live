class UpdateLeaderboardJob
  include Sidekiq::Job

  def perform(*args)
    leaderboard = Bet.leaderboard
    $redis.publish('leaderboard', leaderboard.to_json)
  end
end

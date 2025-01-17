class Bet < ApplicationRecord
    belongs_to :user
    belongs_to :game

    validates :amount, numericality: { greater_than: 0 }
    validates :odds, numericality: { greater_than: 0 }
    validates :pick, presence: true

    validate :game_must_be_open

    

    def self.leaderboard(no_cache = false)

      leaderboard_cache = $redis.get('leaderboard')
      if leaderboard_cache && !no_cache
        JSON.parse(leaderboard_cache)
      else
        leaderboard = User.joins(:bets)
                          # .where(bets: { status: 'won' })
                          .group(:id)
                          .order('SUM(bets.amount) DESC')
                          .limit(10)
                          .select('users.*, SUM(bets.amount) AS total_winnings')
                          .map do |user|
                            { name: user.username, total_winnings: user.total_winnings, id: user.id }
                          end

        $redis.set('leaderboard', leaderboard.to_json, ex: 60) # Cache for 1 minute
        leaderboard
      end

    private
    def game_must_be_open
        errors.add(:game, "is closed for betting") if game&.closed?
    end
end

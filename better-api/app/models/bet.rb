class Bet < ApplicationRecord
    belongs_to :user
    belongs_to :game

    validates :amount, numericality: { greater_than: 0 }
    validates :odds, numericality: { greater_than: 0 }
    validates :pick, presence: true

    validate :game_must_be_open

    

    def self.leaderboard
        User.joins(:bets)
                          .where(bets: { status: 'won' })
                          .group(:id)
                          .order('SUM(bets.amount) DESC')
                          .limit(10)
                          .select('users.*, SUM(bets.amount) AS total_winnings')
                          .map do |user|
                            { name: user.name, total_winnings: user.total_winnings }
                          end
      end

    private
    def game_must_be_open
        errors.add(:game, "is closed for betting") if game&.closed?
    end


end

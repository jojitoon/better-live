class Bet < ApplicationRecord
    belongs_to :user
    belongs_to :game

    validates :amount, numericality: { greater_than: 0 }
    validates :odds, numericality: { greater_than: 0 }
    validates :pick, presence: true

    validate :game_must_be_open

    
    private
    def game_must_be_open
        errors.add(:game, "is closed for betting") if game&.closed?
    end
end

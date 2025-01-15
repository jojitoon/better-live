class Game < ApplicationRecord
    has_many :events
    has_many :bets
    has_many :users, through: :bets

    validates :home_team, presence: true
    validates :away_team, presence: true

    def closed?
        time_elapsed > 90
    end

    def self.active_games
        Game.where(time_elapsed: 0..90).includes(:events)
    end

    def self.create_new_game(home_team, away_team)
        Game.create(home_team: home_team, away_team: away_team)
    end

    def update_score(home_score, away_score)
        update(home_score: home_score, away_score: away_score)
    end

    def update_time(time_elapsed)
        update(time_elapsed: time_elapsed)
    end

    def update_status(status)
        update(status: status)
    end

    def create_new_event(type, team, minute, player)
        events.create(type: type, team: team, minute: minute, player: player)
        $redis.publish('events', { type: type, team: team, minute: minute, player: player }.to_json)
    end
end

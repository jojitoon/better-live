
class Game < ApplicationRecord
    require 'faker'
    has_many :events
    has_many :bets
    has_many :users, through: :bets

    validates :home_team, presence: true
    validates :away_team, presence: true

    after_save :generate_odds

    def closed?
        time_elapsed > 90 * 60
    end

    def self.active_games
        Game.where(time_elapsed: 0..90* 60) #.includes(:events)
    end

    def self.create_new_game(home_team, away_team)
        Game.create(home_team: home_team, away_team: away_team, id: SecureRandom.uuid, home_score: 0, away_score: 0, time_elapsed: 0)
    end

    def update_score(score_type, score)
        score_type = score_type.to_sym
        update(score_type => score)
    end

    def update_time(time_elapsed)
        update(time_elapsed: time_elapsed)
    end


    def create_new_event(type, team, minute, player)
        events.create(event_type: type, team: team, minute: minute, player: player, game_id: id, id: SecureRandom.uuid)
        if type == 'goal' || type == 'penalty'
            update_score("#{team}_score", self["#{team}_score"] + 1)
        end
        if type == 'own-goal'
            other_team = team == 'home' ? 'away' : 'home'
            update_score("#{other_team}_score", self["#{other_team}_score"] + 1)
        end
        update_time(time_elapsed + minute)
        $redis.publish('events', { event_type: type, team: team, minute: minute, player: player }.to_json)
    end


    def generate_odds
       odds = Game.calculate_odds(home_team, away_team)
       self.update_column(:odds, odds)
    end

    def self.refresh_games
        current_active_games = self.active_games
        if current_active_games.count < 6
            self.generate_games(6 - current_active_games.count)
        end
        current_active_games.each do |game|
           team = ['home', 'away'].sample
           event_type = ['goal', 'yellow-card', 'red-card', 'injury', 'substitution', 'penalty', 'own-goal', 'penalty-caused'].sample
           minute =  rand(1..10) * 60
           player = Faker::Name.name
           game.create_new_event(event_type, team, minute, player)
        end

        $redis.publish('games', self.active_games.to_json)
        self.sanitize_redis_cache
    end


    def self.generate_games(count = 1)
        count.times do
            generate_game
        end
    end

    def self.generate_game
        teams = self.high_score_teams + self.low_score_teams
        home_team = teams.sample
        away_team = teams.sample
        teams_set_cache = $redis.smembers('teams_set_cache')

        puts "STATE",teams_set_cache
        while teams_set_cache.include?(home_team) || teams_set_cache.include?(away_team)
            home_team = teams.sample if teams_set_cache.include?(home_team)
            away_team = teams.sample if teams_set_cache.include?(away_team)
        end

        $redis.sadd('teams_set_cache', [home_team, away_team])

        Game.create_new_game(home_team, away_team)
    end

    private

    def self.high_score_teams
        ['Mancester City', 'Liverpool', 'Arsenal', 'Manchester United', 'Tottenham Hotspur', 'Aston Villa',  'Chelsea', 'West Ham United', 'Newcastle United', 'Brighton and Hove Albion', 'Crystal Palace']
    end

    def self.low_score_teams
        ['Burnley', 'Leicester City', 'Wolverhampton Wanderers', 'Southampton', 'Nottingham Forest', 'Everton', 'Leeds United', 'Bournemouth', 'AFC Bournemouth', 'West Bromwich Albion']
    end


    def self.pick_team_to_win(team1, team2)
        if self.high_score_teams.include?(team1) && self.low_score_teams.include?(team2)
            team1
        elsif self.high_score_teams.include?(team2) && self.low_score_teams.include?(team1)
            team2
        else
            [team1, team2].sample
        end
    end

    def self.pick_team_to_win_or_lose(team1, team2)
        win_team = self.pick_team_to_win(team1, team2)

        {
            win_team: win_team,
            lose_team: win_team == team1 ? team2 : team1
        }
    end

    def self.sanitize_redis_cache
        $redis.del('teams_set_cache')
        self.active_games.each do |game|
            $redis.sadd('teams_set_cache', [game.home_team, game.away_team])
        end
        nil
    end

    def self.calculate_odds(home_team, away_team)
        win_team, lose_team = self.pick_team_to_win_or_lose(home_team, away_team)

        home_to_win = win_team == home_team ? true : false

        {
            home: home_to_win ? 1.0 : 0.5,
            draw: 0.5,
            away: home_to_win ? 0.5 : 1.0,
            exact_score: {
                "1_1": 1.0,
                "2_1": 2.0,
                "3_1": 3.0,
                "4_1": 4.0,
                "5_1": 5.0,
                "1_2": 1.0,
                "2_2": 2.0,
                "3_2": 3.0,
                "4_2": 4.0,
                "5_2": 5.0,
                "1_3": 1.0,
                "2_3": 2.0,
                "3_3": 3.0,
                "4_3": 4.0,
                "5_3": 5.0,
                "1_4": 1.0,
                "2_4": 2.0,
                "3_4": 3.0,
                "4_4": 4.0,
                "5_4": 5.0,
                "1_5": 1.0,
                "2_5": 2.0,
                "3_5": 3.0,
                "4_5": 4.0,
                "5_5": 5.0,
                "1_6": 1.0,
                "2_6": 2.0,
                "3_6": 3.0,
                "4_6": 4.0,
                "5_6": 5.0,
                "1_7": 1.0,
                "2_7": 2.0,
                "3_7": 3.0,
                "4_7": 4.0,
            },
            under: {
                "1_5": 1.0,
                "2_5": 2.0,
                "3_5": 3.0,
                "4_5": 4.0,
                "5_5": 5.0,   
            },
            over: {
                "1_5": 1.0,
                "2_5": 2.0,
                "3_5": 3.0,
                "4_5": 4.0,
                "5_5": 5.0,   
            }   
        }
    end
end

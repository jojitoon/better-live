# spec/factories/bets.rb
FactoryBot.define do
    factory :bet do
      id { SecureRandom.uuid }
      user
      game
      amount { 100.0 }
      odds { 1.5 }
      pick { ['home_team', 'away_team'].sample }
      bet_type { 'regular' }
    end
  end
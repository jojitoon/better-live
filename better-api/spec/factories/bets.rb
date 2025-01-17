# spec/factories/bets.rb
FactoryBot.define do
    factory :bet do
      user
      game
      amount { 100.0 }
      odds { 1.5 }
      pick { 'home_team' }
      status { 'pending' }
    end
  end
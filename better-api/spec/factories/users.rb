# spec/factories/users.rb
FactoryBot.define do
    factory :user do
      username { Faker::Internet.username }
      email { Faker::Internet.email }
      password { 'password123' }
      balance { 1000.0 }
    end
  end
  
  # spec/factories/games.rb
  FactoryBot.define do
    factory :game do
      home_team { Faker::Sports::Football.team }
      away_team { Faker::Sports::Football.team }
      status { 'open' }
  
      trait :closed do
        status { 'closed' }
      end
    end
  end
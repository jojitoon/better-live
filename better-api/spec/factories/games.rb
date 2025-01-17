FactoryBot.define do
  factory :game do
    id { SecureRandom.uuid }
    home_team { Faker::Sports::Football.team }
    away_team { Faker::Sports::Football.team }
    home_score { 0 }
    away_score { 0 }
    time_elapsed { 0 }

    trait :closed do
      time_elapsed { 91 * 60 }
    end
  end
end
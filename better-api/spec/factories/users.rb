FactoryBot.define do
    factory :user do
      id { SecureRandom.uuid }
      email { Faker::Internet.email }
      username { Faker::Internet.username }
      name { Faker::Name.name }
      password { 'password123' }
      balance { 1000.0 }
    end
  end


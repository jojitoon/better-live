# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Seed data for games
live_game_data = [
  {
    game_id: 'G1',
    home_team: 'Team A',
    away_team: 'Team B',
    home_score: 2,
    away_score: 1,
    time_elapsed: 65,
    events: [
      { type: 'goal', team: 'home', player: 'Player 1', minute: 23 },
      { type: 'goal', team: 'away', player: 'Player 5', minute: 41 },
      { type: 'goal', team: 'home', player: 'Player 2', minute: 62 }
    ]
  },
  {
    game_id: 'G2',
    home_team: 'Team C',
    away_team: 'Team D',
    home_score: 0,
    away_score: 0,
    time_elapsed: 30,
    events: [
      { type: 'yellowCard', team: 'away', player: 'Player 8', minute: 17 }
    ]
  }
]

live_game_data.each do |game_data|
  Game.find_or_create_by(
    id: game_data[:game_id],
    home_team: game_data[:home_team],
    away_team: game_data[:away_team],
    home_score: game_data[:home_score],
    away_score: game_data[:away_score],
    time_elapsed: game_data[:time_elapsed],
    # events: game_data[:events]
  )
end

# Seed data for users
users = [
  { id: 'U1', username: 'JohnDoe', balance: 1000 },
  { id: 'U2', username: 'JaneSmith', balance: 1500 },
  { id: 'U3', username: 'MikeJohnson', balance: 800 }
]

users.each do |user_data|
  User.create!(
    id: user_data[:id],
    username: user_data[:username],
    balance: user_data[:balance],
    password: 'password',
    email: "#{user_data[:username]}@example.com",
    name: user_data[:username]
  )
end

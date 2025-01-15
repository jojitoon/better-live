# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_01_15_175334) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "bets", id: :string, force: :cascade do |t|
    t.string "user_id", null: false
    t.string "game_id", null: false
    t.float "amount"
    t.float "odds"
    t.string "bet_type"
    t.string "pick"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_bets_on_game_id"
    t.index ["user_id"], name: "index_bets_on_user_id"
  end

  create_table "events", id: :string, force: :cascade do |t|
    t.string "type"
    t.string "team"
    t.integer "minute"
    t.string "player"
    t.string "games_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["games_id"], name: "index_events_on_games_id"
  end

  create_table "games", id: :string, force: :cascade do |t|
    t.string "home_team"
    t.string "away_team"
    t.integer "home_score"
    t.integer "away_score"
    t.integer "time_elapsed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :string, force: :cascade do |t|
    t.string "name"
    t.string "username"
    t.string "email"
    t.string "password_digest"
    t.float "balance", default: 0.0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "bets", "games"
  add_foreign_key "bets", "users"
  add_foreign_key "events", "games", column: "games_id"
end

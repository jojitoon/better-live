class CreateGames < ActiveRecord::Migration[8.0]
  def change
    create_table :games, id: :string do |t|
      t.string :home_team
      t.string :away_team
      t.integer :home_score, default: 0
      t.integer :away_score, default: 0
      t.integer :time_elapsed, default: 0

      t.timestamps
    end
  end
end

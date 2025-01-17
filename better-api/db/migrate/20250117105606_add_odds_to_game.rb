class AddOddsToGame < ActiveRecord::Migration[8.0]
  def change
    add_column :games, :odds, :json, default: {}
  end
end

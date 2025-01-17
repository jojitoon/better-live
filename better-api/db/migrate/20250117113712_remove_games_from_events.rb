class RemoveGamesFromEvents < ActiveRecord::Migration[8.0]
  def change
    remove_reference :events, :games, null: false, foreign_key: true
    add_reference :events, :game, null: false, foreign_key: true, type: :string
  end
end

class CreateBets < ActiveRecord::Migration[8.0]
  def change
    create_table :bets, id: :string do |t|
      t.references :user, null: false, foreign_key: true, type: :string
      t.references :game, null: false, foreign_key: true, type: :string
      t.float :amount
      t.float :odds
      t.string :bet_type
      t.string :pick
      t.string :status

      t.timestamps
    end
  end
end

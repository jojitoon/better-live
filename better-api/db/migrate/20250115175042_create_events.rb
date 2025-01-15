class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :events, id: :string do |t|
      t.string :type 
      t.string :team
      t.integer :minute
      t.string :player
      t.references :games, null: false, foreign_key: true, type: :string

      t.timestamps
    end
  end
end

class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users, id: :string do |t|
      t.string :name
      t.string :username
      t.string :email
      t.string :password_digest
      t.float :balance, default: 0

      t.timestamps
    end
  end
end

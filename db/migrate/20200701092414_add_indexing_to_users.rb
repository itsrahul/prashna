class AddIndexingToUsers < ActiveRecord::Migration[6.0]
  def change
    add_index :users, :email, unique: true
    add_index :users, :verification_token, unique: true
    add_index :users, :reset_token, unique: true
  end
end

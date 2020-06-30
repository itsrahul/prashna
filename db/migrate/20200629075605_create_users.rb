class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email, null: false
      t.string :password_digest
      t.boolean :role, default: false, null: false
      t.integer :credits, default: 0, null: false
      t.string :verfication_token
      t.datetime :verfication_token_expire
      t.string :reset_token
      t.datetime :reset_token_expire
      t.datetime :verification_at

      t.timestamps
    end
  end
end

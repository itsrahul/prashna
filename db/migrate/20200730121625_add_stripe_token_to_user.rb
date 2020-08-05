class AddStripeTokenToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :stripe_token, :string
    add_index :users, :stripe_token
  end
end

class AddIndexingToColumns < ActiveRecord::Migration[6.0]
  def change
    add_index :credit_transactions, :transaction_type
    add_index :topics, :name, unique: true
  end
end

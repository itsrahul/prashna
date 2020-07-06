class AddColumnToCreditTransactions < ActiveRecord::Migration[6.0]
  def change
    add_column :credit_transactions, :transaction_type, :integer, default: 1, null: false
  end
end

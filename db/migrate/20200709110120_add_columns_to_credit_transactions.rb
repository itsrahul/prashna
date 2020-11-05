class AddColumnsToCreditTransactions < ActiveRecord::Migration[6.0]
  def change
    add_column :credit_transactions, :creditable_id, :bigint
    add_column :credit_transactions, :creditable_type, :string
    add_index :credit_transactions, [:creditable_id, :creditable_type]
  end
end

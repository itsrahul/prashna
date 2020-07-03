class CreateCreditTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :credit_transactions do |t|
      t.references :user, foreign_key: true
      t.integer :value
      t.text :reason

      t.timestamps
    end
  end
end

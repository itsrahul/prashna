class CreatePaymentTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :payment_transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :pack, null: false, foreign_key: true
      t.string :charge_id
      t.integer :status, default: 0
      t.datetime :success_at
      t.index :charge_id

      t.timestamps
    end
  end
end

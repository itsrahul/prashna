class CreatePacks < ActiveRecord::Migration[6.0]
  def change
    create_table :packs do |t|
      t.string :name, index: { unique: true }
      t.integer :value, null: false
      t.decimal :price, precision: 8, scale: 2, null: false
      t.integer :status, default: 1, null: false, index: true

      t.timestamps
    end
  end
end

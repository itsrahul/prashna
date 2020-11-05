class CreateApiRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :api_requests do |t|
      t.string :address
      t.index :address

      t.timestamps
    end
  end
end

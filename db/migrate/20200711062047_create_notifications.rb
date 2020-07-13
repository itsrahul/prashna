class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.references :user, foreign_key: true,  null: false
      t.text :message
      t.datetime :read_at
      t.integer :notifiable_id
      t.string :notifiable_type
      t.index [:notifiable_id, :notifiable_type]
      
      t.timestamps
    end
  end
end

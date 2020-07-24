class CreateUserFollowers < ActiveRecord::Migration[6.0]
  def change
    create_table :user_followers do |t|
      t.references :follower, foreign_key: {to_table: :users},  null: false
      t.references :followed, foreign_key: {to_table: :users},  null: false
      t.index [:follower_id, :followed_id], unique: true

      t.timestamps
    end
  end
end

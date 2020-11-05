class CreateVotes < ActiveRecord::Migration[6.0]
  def change
    create_table :votes do |t|
      t.references :user, foreign_key: true,  null: false
      t.boolean :value, default: true
      t.integer :votable_id
      t.string :votable_type
      t.index [:votable_id, :votable_type]

      t.timestamps
    end
  end
end

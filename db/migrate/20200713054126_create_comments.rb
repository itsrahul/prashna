class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.references :user, null: false, foreign_key: true
      t.text :content
      t.integer :commentable_id
      t.string :commentable_type
      t.index [:commentable_id, :commentable_type]

      t.timestamps
    end
  end
end

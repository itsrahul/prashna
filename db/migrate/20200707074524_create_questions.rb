class CreateQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :questions do |t|
      t.string :title, index: { unique: true }
      t.references :user, foreign_key: true
      t.text :content
      t.integer :status, default: 0, null: false
      t.string :slug, index: { unique: true }

      t.timestamps
    end
  end
end

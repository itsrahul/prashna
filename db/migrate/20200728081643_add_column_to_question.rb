class AddColumnToQuestion < ActiveRecord::Migration[6.0]
  def change
    add_column :questions, :published_at, :datetime
    add_index :questions, :published_at
  end
end

class AddColumnsToAnswers < ActiveRecord::Migration[6.0]
  def change
    add_column :answers, :comments_count, :integer, default: 0, null: false
  end
end

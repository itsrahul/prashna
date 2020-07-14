class AddColumnsToQuestions < ActiveRecord::Migration[6.0]
  def change
    add_column :questions, :answers_count, :integer, default: 0, null: false
    add_column :questions, :comments_count, :integer, default: 0, null: false
  end
end

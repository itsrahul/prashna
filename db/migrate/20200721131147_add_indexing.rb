class AddIndexing < ActiveRecord::Migration[6.0]
  def change
    add_index :questions, :status
    add_index :questions, :abuse_status
    add_index :answers, :abuse_status
    add_index :comments, :abuse_status
  end
end

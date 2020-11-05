class ChangeAbuseStatusColumnType < ActiveRecord::Migration[6.0]
  def change
    change_column :questions, :abuse_status, :integer
    change_column :answers, :abuse_status, :integer
    change_column :comments, :abuse_status, :integer
  end
end

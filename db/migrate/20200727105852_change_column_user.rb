class ChangeColumnUser < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :role, :integer
    change_column :users, :disable_status, :integer
  end
end

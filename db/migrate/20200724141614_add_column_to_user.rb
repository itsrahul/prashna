class AddColumnToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :disable_status, :boolean, default: false
  end
end

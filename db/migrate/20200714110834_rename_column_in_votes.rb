class RenameColumnInVotes < ActiveRecord::Migration[6.0]
  def change
    rename_column :votes, :value, :vote_type
  end
end

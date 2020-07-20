class ChangeColumnInVotes < ActiveRecord::Migration[6.0]
  def change
    change_column :votes, :vote_type, :integer
  end
end

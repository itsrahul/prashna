class AddNetUpVotesColumns < ActiveRecord::Migration[6.0]
  def change
    add_column :answers, :net_upvotes, :integer, default: 0
    add_column :comments, :net_upvotes, :integer, default: 0
  end
end

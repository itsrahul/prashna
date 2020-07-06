class CreateTopicsUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :topics_users, id: false do |t|
      t.belongs_to :topic
      t.belongs_to :user
    end
  end
end

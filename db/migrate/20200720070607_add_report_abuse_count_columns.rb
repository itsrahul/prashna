class AddReportAbuseCountColumns < ActiveRecord::Migration[6.0]
  def change
    add_column :questions, :abuse_status, :boolean, default: false, null: false
    add_column :answers,   :abuse_status, :boolean, default: false, null: false
    add_column :comments,  :abuse_status, :boolean, default: false, null: false

  end
end

class CreateAbuseReports < ActiveRecord::Migration[6.0]
  def change
    create_table :abuse_reports do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :abusable_id
      t.string :abusable_type
      t.string :reason
      t.index [:abusable_id, :abusable_type]

      t.timestamps
    end
  end
end

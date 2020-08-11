class ChangeColumnInPacks < ActiveRecord::Migration[6.0]
  def change
    rename_column :packs, :value, :credit
  end
end

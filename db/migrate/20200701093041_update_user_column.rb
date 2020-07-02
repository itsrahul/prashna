class UpdateUserColumn < ActiveRecord::Migration[6.0]
  def change
    change_table :users do |t|
      t.rename :verfication_token, :verification_token
      t.rename :verfication_token_expire, :verification_token_expire
      
    end
  end
end

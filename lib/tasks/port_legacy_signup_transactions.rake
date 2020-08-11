desc "Port signup transaction's creditable from User to Pack"
task :port_legacy_signup_transactions => :environment do
  CreditTransaction.where(creditable_type: User).find_each do |ct|
    signup_pack = Pack.find_by_name("signup")
    ct.update_columns(value: signup_pack.credit, creditable_id: signup_pack.id, creditable_type: Pack)
    puts "#{ct.id} successfully updated."
  end
end
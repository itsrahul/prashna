desc "Update signup pack credit value"
task :update_signup_pack_credits => :environment do

  update_pack_signup = Pack.signup.update(credit: ENV['signup_credits'])
  if update_pack_signup
    puts "Pack updated successfully."
    CreditTransaction.signup.find_each do |signup_ct|
      signup_ct.update(value: Pack.signup.credit)
    end
  else
    puts "\nErrors while updating pack."
  end
end
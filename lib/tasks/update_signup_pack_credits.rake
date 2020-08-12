desc "Update signup pack credit value"
task :update_signup_pack_credits => :environment do

  update_pack_signup = Pack.signup.update(credit: ENV['signup_credits'])
  if update_pack_signup
    puts "Pack updated successfully."
  else
    puts "\nErrors while updating pack."
  end
end
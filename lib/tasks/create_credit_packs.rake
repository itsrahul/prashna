desc "Create new credit packs"
task :create_credit_packs => :environment do

  pack_signup = Pack.unlisted.new(name: "Signup", credit: ENV['signup_credits'], price: 0).save
  pack_s = Pack.listed.new(name: "Small", credit: 5, price: 49).save
  pack_m = Pack.listed.new(name: "Medium", credit: 10, price: 89).save
  pack_l = Pack.listed.new(name: "Large", credit: 20, price: 149).save
  if [pack_signup, pack_s, pack_m, pack_l].all?
    puts "Packs created successfully."
  else
    puts "\nErrors while creating packs."
  end
end
namespace :admin do
  #FIXME_AB: update description
  desc "Assign admin to role user"
  task :new => :environment do
    def get_detail(prompt)
      print prompt
      STDIN.readline.chomp
    end

    #FIXME_AB: make use of tagged logging

    admin = User.admin.new(
      name: get_detail("Name: "),
      email: get_detail("Email: "),
      #FIXME_AB: password should not be shown on console when entered
      password: get_detail("Password: ")
    )
    if admin.save && admin.activate!
      puts "Admin account created."
    else
      puts "Errors while creating admin account."
      #FIXME_AB: admin.errors.full_messages
      admin.errors.each{ |err, msg| puts "#{err.capitalize} #{msg}" }
    end
  end
end

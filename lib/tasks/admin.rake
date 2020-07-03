namespace :admin do
  desc "Assign admin to role user"
  task :new => :environment do
    def get_detail(prompt)
      print prompt
      STDIN.readline.chomp
    end

    admin = User.admin.new(
      name: get_detail("Name: "),
      email: get_detail("Email: "),
      password: get_detail("Password: ")
    )
    if admin.save && admin.activate!
      puts "Admin account created."
    else
      puts "Errors while creating admin account."
      admin.errors.each{ |err, msg| puts "#{err.capitalize} #{msg}" }
    end
  end
end
namespace :admin do

  desc "Create admin account"
  task :new => :environment do
    def get_detail(prompt)
      print prompt
      STDIN.readline.chomp
    end

    def get_secure(prompt)
      print prompt
      STDIN.noecho(&:readline).chomp
    end

    #FIXME_AB: Rails.logger.tagged() do
    # end
    Rails.logger.tagged('admin:new') do
      admin = User.admin.new(
        name: get_detail("Name: "),
        email: get_detail("Email: "),
        password: get_secure("Password: ")
      )
      if admin.save && admin.activate!
        puts "Admin account created."
      else
        puts "Errors while creating admin account."
        admin.errors.full_messages.each{ |message| puts message }
      end
    end
  end
end

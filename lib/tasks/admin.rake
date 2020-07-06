namespace :admin do
  #FIXME_AB: update description
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

    #FIXME_AB: make use of tagged logging

    logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))
    admin = User.admin.new(
      name: get_detail("Name: "),
      email: get_detail("Email: "),
      #FIXME_AB: password should not be shown on console when entered
      password: get_secure("Password: ")
    )
    if admin.save && admin.activate!
      puts "Admin account created."
      logger.tagged('admin:new') { logger.info 'new admin account created'}
    else
      puts "Errors while creating admin account."
      #FIXME_AB: admin.errors.full_messages
      admin.errors.full_messages.each{ |message| puts message }
      logger.tagged('admin:new') { logger.info 'error creating admin account'}
    end
  end
end

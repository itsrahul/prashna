class ApplicationMailer < ActionMailer::Base
  #FIXME_AB: this from email should come from env.

  default from: ENV['default_mail']
  layout 'mailer'
end

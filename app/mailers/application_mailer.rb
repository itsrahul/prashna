class ApplicationMailer < ActionMailer::Base
  #FIXME_AB: this from email should come from env.

  default from: 'admin@prashna.com'
  layout 'mailer'
end

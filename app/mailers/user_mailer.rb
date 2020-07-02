class UserMailer < ApplicationMailer

  #FIXME_AB: send html emails instead of text mails

  def verification_mail(id)
    @user = User.unverified.find(id)
    #FIXME_AB: check that
    #FIXME_AB: 1. user is found
    #FIXME_AB: 2. not already verified.
    #FIXME_AB: User.unverified.find(id)

    #FIXME_AB: lets use mail intercepters to add environment in the subject line, other than production env
    #FIXME_AB: [development] Prashna......
    #FIXME_AB: action_mailer_basics.html#intercepting-emails
    mail to: @user.email, subject: t('.subject')
  end

  def password_reset_mail(id)
    @user = User.find(id)

    mail to: @user.email, subject: t('.subject')

  end
end

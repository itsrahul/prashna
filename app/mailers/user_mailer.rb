class UserMailer < ApplicationMailer


  def verification_mail(id)
    @user = User.unverified.find(id)
    #FIXME_AB: check that
    #FIXME_AB: 1. user is found

    mail to: @user.email, subject: t('.subject')
  end

  def password_reset_mail(id)
    @user = User.find(id)

    mail to: @user.email, subject: t('.subject')

  end
end

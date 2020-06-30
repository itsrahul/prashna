class UserMailer < ApplicationMailer

  def verification_mail(id)
    @user = User.find(id)

    mail to: @user.email, subject: 'Prashna: Verification Mail'
  end

  def password_reset_mail(id)
    @user = User.find(id)

    mail to: @user.email, subject: 'Prashna: Password Reset Mail'

  end
end

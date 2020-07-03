class UserMailer < ApplicationMailer


  def verification_mail(id)
    @user = User.unverified.find(id)

    if @user
      mail to: @user.email, subject: t('.subject')
    end
  end

  def password_reset_mail(id)
    @user = User.find(id)

    if @user
      mail to: @user.email, subject: t('.subject')
    end
  end
end

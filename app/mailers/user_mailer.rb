class UserMailer < ApplicationMailer


  def verification_mail(id)
    @user = User.enabled.unverified.find(id)

    if @user
      mail to: @user.email, subject: t('.subject')
    end
  end

  def password_reset_mail(id)
    @user = User.enabled.find(id)

    if @user
      mail to: @user.email, subject: t('.subject')
    end
  end

  def answer_posted_mail(id, question_id)
    @user = User.enabled.find(id)
    @question = Question.published.find(question_id)
    

    if (@user && @question)
      mail to: @user.email, subject: t('.subject')
    end
  end
end

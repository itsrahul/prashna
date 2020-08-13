module QuestionPublished
  include ActiveSupport::Concern

  def notify_users_except(current_user)
    #done FIXME_AB: should not generate multiple notifications for same question for a same user
    (topics.collect_concat(&:users).uniq-[current_user]).each do |user|
      user.notifications.create(notifiable: self)
    end
  end

  def charge_credits(current_user)
    credit_transactions.question.create(user: user, value: -1 * ENV['credit_for_question_post'].to_i, reason: I18n.t('.question_published'))
  end

end

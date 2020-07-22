module QuestionPublished
  include ActiveSupport::Concern

  def notify_users_except(current_user)
    #FIXME_AB: should not generate multiple notifications for same question for a same user
    self.topics.includes(:users).each do |topic|
      (topic.users- [current_user]).each do |user|
        user.notifications.create(message: topic.name, notifiable: self)
      end
    end
  end

  def charge_credits(current_user)
    credit_transactions.question.create(user: user, value: -1 * ENV['credit_for_question_post'].to_i, reason: "Question published")
  end

end

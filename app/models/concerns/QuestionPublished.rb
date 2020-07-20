module QuestionPublished
  include ActiveSupport::Concern

  def notify_users_except(current_user)
    #done FIXME_AB: eager load users
    self.topics.includes(:users).each do |topic|
      (topic.users- [current_user]).each do |user|
        #done FIXME_AB: user.notifications.create
        #done FIXME_AB: lets not generate message here, we'll dynamically create message when needed using user_id and the entity.
        # should we store topic name for generating message?
        user.notifications.create(message: topic.name, notifiable: self)
        # Notification.create(user: user, message: "New #{self.class} published on #{topic.name}", notifiable: self)
      end
    end
  end

  def charge_credits(current_user)
    #done FIXME_AB: Transaction type question. So when question is posted, use that, instead or others
    #done FIXME_AB: user.credit_transactions.create.. this leads to creditable being user instead of question. required for check later
    #done FIXME_AB: -1 * ENV['credit_for_question_post'].to_i
    credit_transactions.question.create(user: user, value: -1 * ENV['credit_for_question_post'].to_i, reason: "Question published")
  end

end

module QuestionPublished
  include ActiveSupport::Concern

  # included do
    # before_action :set_pbject, only: [:show, :edit, :destroy, :update]
  # end

  def notify_question_pubished(current_user)
    #FIXME_AB: eager load users
    self.topics.each do |topic|
      (topic.users- [current_user]).each do |user|
        #FIXME_AB: user.notifications.create
        #FIXME_AB: lets not generate message here, we'll dynamically create message when needed using user_id and the entity.
        Notification.create(user: user, message: "New #{self.class} published on #{topic.name}", notifiable: self)
        # debugger
      end
    end
  end

  def charge_credits(current_user)
    #FIXME_AB: Transaction type question. So when question is posted, use that, instead or others
    #FIXME_AB: user.credit_transactions.create..
    #FIXME_AB: -1 * ENV['credit_for_question_post'].to_i
    CreditTransaction.others.create(user: current_user, value: -ENV['credit_for_question_post'].to_i, reason: "Question published", creditable: self)
  end

end

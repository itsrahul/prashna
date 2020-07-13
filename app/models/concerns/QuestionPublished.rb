module QuestionPublished
  include ActiveSupport::Concern

  # included do
    # before_action :set_pbject, only: [:show, :edit, :destroy, :update]
  # end

  def notify_question_pubished(current_user)
    self.topics.each do |topic|
      (topic.users- [current_user]).each do |user|
        Notification.create(user: user, message: "New #{self.class} published on #{topic.name}", notifiable: self)
        debugger
      end
    end
  end

  def charge_credits(current_user)
    CreditTransaction.others.create(user: current_user, value: -ENV['credit_for_question_post'].to_i, reason: "Question published", creditable: self)
  end

end
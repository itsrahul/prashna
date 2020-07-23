class Notification < ApplicationRecord
  validates :message, presence: true

  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  after_commit :set_message

  scope :unread, -> { where(read_at: nil) }

  def unread?
    read_at.nil?
  end

  def mark_read
    update_columns(read_at: Time.current)
  end  

  private def set_message
    topic_names = user.topics.merge( self.notifiable.topics).pluck(:name).join(', ')
    message = "New #{notifiable_type.downcase} on topics: #{topic_names}"
    update_columns(message: message)
  end
end

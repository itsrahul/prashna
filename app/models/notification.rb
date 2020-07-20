class Notification < ApplicationRecord
  validates :message, presence: true

  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  scope :unread, -> { where(read_at: nil) }

  def unread?
    read_at.nil?
  end

  def mark_read
    update_columns(read_at: Time.current)
  end  
end

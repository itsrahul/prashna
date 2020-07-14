class Notification < ApplicationRecord
  validates :message, presence: true

  belongs_to :user
  belongs_to :notifiable, polymorphic: true
end

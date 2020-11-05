class UserFollower < ApplicationRecord
  validates :followed_id, :follower_id, presence: :true

  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  before_create :ensure_followed_not_self

  private def ensure_followed_not_self
    if follower == followed
      errors.add(:base, I18n.t('.follow_self'))
      throw :abort
    end
  end
end

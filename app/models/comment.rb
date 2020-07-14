class Comment < ApplicationRecord
  validates :content, presence: true

  belongs_to :user
  belongs_to :commentable, polymorphic: true, counter_cache: true
  has_many :votes, as: :votable

end

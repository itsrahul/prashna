class Comment < ApplicationRecord
  validates :content, presence: true
  #FIXME_AB: add min words validation


  belongs_to :user
  belongs_to :commentable, polymorphic: true, counter_cache: true
  has_many :votes, as: :votable

  #FIXME_AB: user should not be able to vote on his own comments

end

class Answer < ApplicationRecord
  validates :content, presence: true

  belongs_to :user
  belongs_to :question
  has_many :comments, as: :commentable
  has_many :votes, as: :votable

end

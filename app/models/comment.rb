class Comment < ApplicationRecord
  validates :content, presence: true
  # validates :words_in_content, length: { minimum: 3}
  #done FIXME_AB: add min words validation


  belongs_to :user
  belongs_to :commentable, polymorphic: true, counter_cache: true
  has_many :votes, as: :votable

  before_create :ensure_question_published

  #done FIXME_AB: user should not be able to vote on his own comments

  def belongs_to_question
    if commentable_type == "Question"
      commentable
    else
      commentable.question
    end
  end

  def words_in_content
    content.scan(/\w+/)
  end

  private def ensure_question_published
    unless belongs_to_question.published?
      errors.add(:base, 'Cannot comment on unpublished question.')
      throw :abort
    end
  end
end

class Comment < ApplicationRecord
  enum abuse_status: { abused: true, unabused: false }

  validates :content, presence: true
  validates :words_in_content, length: { minimum: 3}

  belongs_to :user
  belongs_to :commentable, polymorphic: true, counter_cache: true
  has_many :votes, as: :votable
  has_many :abuse_reports, as: :abusable

  default_scope { unabused }

  before_create :ensure_question_published


  #FIXME_AB: rename this method to just 'question'
  def belongs_to_question
    #FIXME_AB: if comment.commentable.is_a?
                #   return comment.commentable
                # end

                # if comment.commentable.is_a? Answer
                #   return comment.commentable.question
                # end

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

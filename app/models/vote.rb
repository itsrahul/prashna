class Vote < ApplicationRecord

  enum vote_type: { up_vote: 1, down_vote: 0 }

  validates :vote_type, presence: true

  belongs_to :user
  belongs_to :votable, polymorphic: true

  scope :by_votable, -> (votable) { where(votable: votable) }


  before_create :ensure_votable_belongs_to_published_question, :ensure_votable_belongs_to_other_user

  after_commit :refresh_net_votes!

  private def ensure_votable_belongs_to_published_question
    question = vote_belongs_to_question
    if not question.published?
      errors.add(:base, 'Question not yet published')
      throw :abort
    end
  end

  def votable_created_by?(given_user)
    votable.user == given_user ? true : false
  end

  def ensure_votable_belongs_to_other_user
    #FIXME_AB: votable.voted_by?(user)
    # if user == votable.user
    if votable_created_by?(self.user)
      errors.add(:base, 'Cannot vote your own answer/comment.')
      throw :abort
    end
  end

  private def vote_belongs_to_question
    # or directly use votable.question, noo need of function.
    if votable.is_a? Comment
      return votable.question
    end
    if votable.is_a? Answer
      return votable.question
    end
  end

  private def refresh_net_votes!
    #done FIXME_AB: votable.votes.up_vote.count
    # works but runs 2 sql queries, instead of one 
    votable.net_upvotes = Vote.by_votable(votable).up_vote.count - Vote.by_votable(votable).down_vote.count
    votable.save!
  end
end

class Vote < ApplicationRecord

  enum vote_type: { up_vote: 1, down_vote: 0 }

  validates :vote_type, presence: true

  belongs_to :user
  belongs_to :votable, polymorphic: true

  #done FIXME_AB: Vote.by_votable(@question).up_votes.count
  scope :by_votable, -> (votable) { where(votable: votable) }


  #FIXME_AB:  user can vote on comments of published question
  #FIXME_AB:  user can vote on answer of published question
  before_create :ensure_votable_belongs_to_published_question, :ensure_votable_belongs_to_other_user
  
  #done FIXME_AB: we don't need this unless condition
  after_commit :refresh_net_votes!

  private def ensure_votable_belongs_to_published_question
    question = vote_belongs_to_question
    unless question.published?
      errors.add(:base, 'Question not yet published')
      throw :abort
    end
  end

  def ensure_votable_belongs_to_other_user
    if user == votable.user
      errors.add(:base, 'Cannot vote your own answer/comment.')
      throw :abort
    end
  end

  private def vote_belongs_to_question
    if votable_type == "Answer"
      votable.question
    else
      votable.belongs_to_question
    end
  end

  private def refresh_net_votes!
    votable.net_upvotes = Vote.by_votable(votable).up_vote.count - Vote.by_votable(votable).down_vote.count
    votable.save!
  end
end

class Vote < ApplicationRecord

  enum vote_type: { down_vote: false, up_vote: true }

  validates :vote_type, presence: true
  belongs_to :user
  belongs_to :votable, polymorphic: true

#FIXME_AB:  user can vote on comments of published question
#FIXME_AB:  user can vote on answer of published question

  scope :upvote_count, -> (votable) { up_vote.where(votable: votable).size }
  scope :downvote_count, -> (votable) { down_vote.where(votable: votable).size }


  #FIXME_AB: Vote.by_votable(@question).up_votes.count

  #FIXME_AB: we don't need this unless condition
  after_commit :refresh_net_votes!, unless: Proc.new { |vt| vt.user.destroyed? }

  private def refresh_net_votes!
    votable.net_upvotes = Vote.upvote_count(votable) - Vote.downvote_count(votable)
    votable.save!
  end
end

class Vote < ApplicationRecord

  enum vote_type: { down_vote: false, up_vote: true }

  validates :vote_type, presence: true
  belongs_to :user
  belongs_to :votable, polymorphic: true

  after_commit :refresh_net_votes!, unless: Proc.new { |vt| vt.user.destroyed? }

  private def refresh_net_votes!
    votable.net_upvotes = Vote.up_vote.where(votable: votable).size - Vote.down_vote.where(votable: votable).size
    votable.save!
  end
end

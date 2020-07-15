class Answer < ApplicationRecord
  validates :content, presence: true
  #FIXME_AB:  min words validation

  belongs_to :user
  belongs_to :question, counter_cache: true
  has_many :comments, as: :commentable
  has_many :votes, as: :votable

  # after_commit :give_upvote_credit, if: Proc.new {|ans| ans.votes.exists? }

  private def give_upvote_credit
    if net_upvotes >= ENV['upvote_for_bonus_credit'].to_i
      # if net_upvotes > 5, then create c_t for bonus
      # else if net_upvotes < 5 and user.c_t for bonus exists?
      # ans.user.credit_transactions.create(value: 1, reason: "upvotes on ans", creditable: ans)
      # ans.user.credit_transactions.create(value: 1, reason: "upvotes on ans", user: ans.user, creditable: ans)
    end
  end
end

class Answer < ApplicationRecord
  enum abuse_status: { unabused: 0, abused: 1 }
  include Validations

  validates :content, presence: true
  validates :words_in_content, length: { minimum: 3 }, allow_blank: true

  belongs_to :user
  belongs_to :question, counter_cache: true
  #done FIXME_AB: think about dependent optoins
  has_many :comments, as: :commentable, dependent: :restrict_with_error
  has_many :votes, as: :votable, dependent: :restrict_with_error
  has_many :credit_transactions, as: :creditable, dependent: :restrict_with_error
  has_many :abuse_reports, as: :abusable

  default_scope { unabused }

  before_create :ensure_questions_belongs_to_other_user, :ensure_question_published
  after_commit :actions_if_abused
  after_commit :give_net_upvote_based_credit, if: Proc.new {|ans| ans.votes.exists? }

  # def words_in_content
  #   content.scan(/\w+/)
  # end
  def question_posted_by?(given_user)
    given_user == question.user ? true : false
  end

  private def ensure_questions_belongs_to_other_user
    #done FIXME_AB: question.posted_by?(user)
    if question_posted_by?(self.user)
      errors.add(:base, 'Cannot answer your own question.')
      throw :abort
    end
  end

  private def ensure_question_published
    #done FIXME_AB: if not question.published?
    if not question.published?
      errors.add(:base, 'Cannot answer unpublished question.')
      throw :abort
    end
  end

  private def actions_if_abused
    if abused?
      #done FIXME_AB: lets do -1 * abs(sum)
      if not (credit_sum = credit_transactions.sum(:value)).zero?
        credit_transactions.create(user: user, value: -1 * credit_sum.abs, reason: "abuse reported, bonus reverted")
      end
    end
  end

  private def give_net_upvote_based_credit
    #done FIXME_AB: take 1 from env
    if net_upvotes >= ENV['upvote_for_bonus_credit'].to_i
      if credit_transactions.sum(:value).zero?
        credit_transactions.create(user: user, value: ENV['bonus_credit_on_upvotes'], reason: "upvotes bonus add")
      end
    else
      if not credit_transactions.sum(:value).zero?
        credit_transactions.create(user: user, value: -1 * ENV['bonus_credit_on_upvotes'], reason: "upvotes bonus remove")
      end
    end
  end
end

class CreditTransaction < ApplicationRecord
  enum transaction_type: { signup: 1, purchase: 2, question: 3, others: 4}

  validates :value, numericality: { other_than: 0 }

  belongs_to :user
  belongs_to :creditable, polymorphic: true

  after_commit :refresh_credits_balance!, unless: Proc.new { |ct| ct.creditable.destroyed? }

  private def refresh_credits_balance!
    user.credits = user.credit_transactions.sum(&:value)
    # user.credits = CreditTransaction.unscoped.where(user: user).sum(&:value)
    user.save!
  end

end

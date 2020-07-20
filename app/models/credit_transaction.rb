class CreditTransaction < ApplicationRecord
  #done FIXME_AB: Transaction type question. So when question is posted, use that, instead or others
  enum transaction_type: { signup: 1, purchase: 2, question: 3, others: 4}

  validates :value, numericality: { other_than: 0 }

  belongs_to :user
  belongs_to :creditable, polymorphic: true

  after_commit :refresh_credits_balance!, unless: Proc.new { |ct| ct.creditable.destroyed? }

  private def refresh_credits_balance!
    user.credits = CreditTransaction.where(user: user).sum(&:value)
    user.save!
  end

  #done FIXME_AB: I don't think we should have two methods. Lets fix user validation
  # private def refresh_credits_balance
  #   user.update_columns(credits: creditable.credit_transactions.sum(&:value))
  # end
end

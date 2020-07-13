class CreditTransaction < ApplicationRecord
  enum transaction_type: { signup: 1, purchase: 2, others: 3}

  validates :value, numericality: { other_than: 0 }

  #FIXME_AB:Now it polymorphic so that transaction can be related to questions, answers, votes, purchase
  belongs_to :user
  belongs_to :creditable, polymorphic: true

  #done FIXME_AB: use unless: user.destroyed?
  after_commit :refresh_credits_balance!, unless: Proc.new { |ct| (ct.signup? || ct.creditable.destroyed? ) }
  after_commit :refresh_credits_balance, if: Proc.new { |ct| ct.signup? }, unless: Proc.new { |ct| ct.creditable.destroyed? }

  private def refresh_credits_balance!
    # CreditTransaction.default_scoped.where(user_id: 21).sum(&:value)
    # user.credit_transactions.sum(&:value)
    user.credits = CreditTransaction.default_scoped.where(user: user).sum(&:value)
    user.save!
  end

  private def refresh_credits_balance
    user.update_columns(credits: creditable.credit_transactions.sum(&:value))
  end
end

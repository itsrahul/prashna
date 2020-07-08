class CreditTransaction < ApplicationRecord
  enum transaction_type: { signup: 1, purchase: 2}

  validates :value, numericality: { other_than: 0 }

  #FIXME_AB:Now it polymorphic so that transaction can be related to questions, answers, votes, purchase

  belongs_to :user

  #FIXME_AB: use unless: user.destroyed?
  after_commit :refresh_credits_balance!, if: Proc.new { |ct| !ct.user.frozen? }

  private def refresh_credits_balance!
    user.credits = user.credit_transactions.sum(&:value)
    user.save!
  end
end

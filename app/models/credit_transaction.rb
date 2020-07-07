class CreditTransaction < ApplicationRecord
  enum transaction_type: { signup: 1, purchase: 2}

  #FIXME_AB: validations.
  #FIXME_AB: add index on transaction type

  #FIXME_AB: we'll make it polymorphic so that transaction can be related to questions, answers, votes, purchase

  belongs_to :user
 
  validates :value, numericality: { other_than: 0 }

  #FIXME_AB: after commit. call a method refresh_credits_balance! which will update the final credit balance of the user in the user table
  after_commit :refresh_credits_balance!, if: Proc.new { |ct| !ct.user.frozen? }

  private def refresh_credits_balance!
    user.credits = user.credit_transactions.sum(&:value)
    user.save!
  end
end

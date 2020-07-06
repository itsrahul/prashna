class CreditTransaction < ApplicationRecord
  enum transaction_type: { signup: 1, purchase: 2}

  #FIXME_AB: validations.
#FIXME_AB: add index on transaction type

  #FIXME_AB: we'll make it polymorphic so that transaction can be related to questions, answers, votes, purchase

  belongs_to :user

  #FIXME_AB: after commit. call a method refresh_credits_balance! which will update the final credit balance of the user in the user table
end

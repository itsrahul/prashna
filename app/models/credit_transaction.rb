class CreditTransaction < ApplicationRecord
  #FIXME_AB: add a column transation_type and make it enum
  #FIXME_AB: enum {signup: 1, purchase: 2}
  #FIXME_AB: we'll make it polymorphic so that transaction can be related to questions, answers, votes, purchase

  belongs_to :user
end

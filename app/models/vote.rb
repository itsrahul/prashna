class Vote < ApplicationRecord

  enum value: { down_vote: 0, up_vote: 1 }

  validates :value, presence: true

  belongs_to :votable, polymorphic: true

end

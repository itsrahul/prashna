class Topic < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }

  #FIXME_AB: name unique index
  has_and_belongs_to_many :users
  has_and_belongs_to_many :questions

  scope :search, ->(name) {
    where("name like ?", "%#{name}%")
   }
end

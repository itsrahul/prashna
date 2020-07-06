class Topic < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }

  #FIXME_AB: validations
  #FIXME_AB: name unique
  #FIXME_AB: associations
  has_and_belongs_to_many :users

  scope :search, ->(name) { 
    where("name like ?", "%#{name}%")
   }
end

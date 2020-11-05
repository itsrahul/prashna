class Pack < ApplicationRecord
  enum status: { unlisted: 0, listed: 1 }

  validates :name, :credit, :price, :status, presence: true
  validates :credit, numericality: { greater_than: 1 }, allow_blank: true
  validates :price, numericality: { greater_than_or_equal: 0 }, allow_blank: true

  has_many :payment_transactions, dependent: :restrict_with_error

  scope :signup, -> { find_by(name: "signup") }
end

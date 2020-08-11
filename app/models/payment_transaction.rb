class PaymentTransaction < ApplicationRecord
  enum status: { inprogress: 0, success: 1, failed: 2 }

  belongs_to :user
  belongs_to :pack
  has_many :credit_transactions, as: :creditable

  after_commit :actions_on_success, on: [:create, :update]

  private def actions_on_success
    if success?
      user.credit_transactions.create(transaction_type: 'purchase',creditable: self, value: pack.credit, reason: "#{pack.name} Credit Pack Bought")
    end
  end

end

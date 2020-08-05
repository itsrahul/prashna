class PaymentTransaction < ApplicationRecord
  enum status: { inprogress: 0, success: 1, failed: 2 }

  belongs_to :user
  belongs_to :pack
  has_many :credit_transactions, as: :creditable

  after_commit :actions_on_success, on: [:create, :update]

  private def actions_on_success
    if success?
      update_columns(success_at: updated_at)
      user.credit_transactions.purchase.create(creditable: self, value: pack.value, reason: "#{pack.name} Credit Pack Bought")
    end
  end

end

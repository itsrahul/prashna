class PaymentTransaction < ApplicationRecord
  enum status: { inprogress: 0, success: 1, failed: 2 }

  belongs_to :user
  belongs_to :pack
  has_many :credit_transactions, as: :creditable

  after_commit :actions_on_success, on: [:create, :update]

  private def actions_on_success
    if success?
      credit_transactions.purchase.create(user: user, creditable: self, value: pack.credit, reason: I18n.t('.credit_pack_bought', pack_name: pack.name) )
    end
  end

end

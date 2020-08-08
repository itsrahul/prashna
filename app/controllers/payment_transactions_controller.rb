class PaymentTransactionsController < ApplicationController
  before_action :set_pack, only: [:create, :new]

  def index
    @payments = current_user.payment_transactions.includes(:pack).paginate(page: params[:page], per_page: ENV['transaction_pagination_size'].to_i).order(:created_at)
  end

  def new
  end

  def create
    begin
      stripe_token = params[:stripe_token]
      stripe_customer = Stripe::Customer.retrieve(current_user.get_or_create_stripe_token)
      payment = current_user.payment_transactions.inprogress.create(pack: @pack)

      stripe_charge = Stripe::Charge.create({
        amount: @pack.price.to_i*100,
        currency: 'inr',
        source: stripe_token,
        description: "Purchasing Pack - #{@pack.name}",
      })

      Stripe::Charge.update(stripe_charge.id, { customer: stripe_customer.id})
      payment.update_columns(charge_id: stripe_charge.id)

      if stripe_charge.paid
        payment.success!
        # payment.update_columns(success_at: payment.updated_at)
        # current_user.credit_transactions.purchase.create(creditable: payment, value: @pack.value, reason: 'Credit Pack Bought')
      else
        payment.failed!
        redirect_to pack_payment_path, notice: "Transaction failed."
      end

    rescue  Stripe::CardError => e
      current_user.payment_transactions.last.failed!
      redirect_to pack_payment_path, notice: e.message
    end
  end

  private def set_pack  
    if not (@pack = Pack.find(params[:id]))
      redirect_to purchase_packs_path, notice: "Invalid pack."
    end
  end

end

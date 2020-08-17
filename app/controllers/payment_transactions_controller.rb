class PaymentTransactionsController < ApplicationController
  before_action :set_pack, only: [:create, :new]

  def index
    @payments = current_user.payment_transactions.includes(:pack).paginate(page: params[:page], per_page: ENV['transaction_pagination_size'].to_i).order(:created_at)
  end

  def new
  end

  def create
    begin
      stripe_card_token = params[:stripe_token]

      if not StripeServices.makePayment(stripe_card_token, current_user, @pack)
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

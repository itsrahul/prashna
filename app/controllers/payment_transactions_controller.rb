class PaymentTransactionsController < ApplicationController

  def index
    @payments = current_user.payment_transactions.includes([:pack,]).paginate(page: params[:page], per_page: ENV['transaction_pagination_size'].to_i).order(:created_at)
  end

end

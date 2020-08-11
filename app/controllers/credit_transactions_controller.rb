class CreditTransactionsController < ApplicationController

  def index
    @transactions = current_user.credit_transactions.includes([:creditable]).paginate(page: params[:page], per_page: ENV['transaction_pagination_size'].to_i).order(updated_at: :desc)
  end

end

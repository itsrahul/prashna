class CreditTransactionsController < ApplicationController
  # before_action :ensure_logged_in

  def index
    @transactions = current_user.credit_transactions.includes([:creditable]).paginate(page: params[:page], per_page: ENV['transaction_pagination_size'].to_i).order(updated_at: :desc)
  end

  # private def ensure_logged_in
  #   if not logged_in?
  #     redirect_to root_path, notice: t('.login_req')
  #   end
  # end
end

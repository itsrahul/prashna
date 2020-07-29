class CreditTransactionsController < ApplicationController
  before_action :ensure_logged_in

  def index
    # @transactions = current_user.credit_transactions.paginate(page: params[:page], per_page: ENV['pagination_size'].to_i)
    # above check for (creditable: current_user), not (user: current_user).
    @transactions = CreditTransaction.includes([:creditable]).where(user: current_user).paginate(page: params[:page], per_page: ENV['transaction_pagination_size'].to_i).order(updated_at: :desc)
  end

  private def ensure_logged_in
    if not logged_in?
      redirect_to root_path, notice: t('.login_req')
    end
  end
end

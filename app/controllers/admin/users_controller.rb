module Admin
  class UsersController < AdminController
    before_action :set_user, only: [:show, :disable, :enable]
    def index
      @users = User.all.paginate(page: params[:page])
    end

    #done FIXME_AB: lets show complete info of learner that we have including credit transactions.
    def show
      @credit_transactions = @user.credit_transactions.paginate(page: params[:page])
    end

    def disable
      @user.disabled!
      redirect_to admin_users_path, notice: "User disabled successfully."
    end

    def enable
      @user.enabled!
      redirect_to admin_users_path, notice: "User re-enabled successfully."
    end

    private def set_user
      @user = User.find(params[:id])
    end
  end
end
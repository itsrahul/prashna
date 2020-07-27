class Admin::UsersController < AdminController
  before_action :set_user, only: [:show, :disable, :enable]
  def index
    @users = User.user.all
  end

  def show
    @user.includes(:questions, :answers, :comments)
  end

  def disable
    # mark user disable.
    # disabled user can't login.
    @user.disabled!
    redirect_to admin_users_path, notice: "User disabled successfully."
  end

  def enable
    # if params[:status].to_i == 1
    #   @user.disabled!
    # elsif params[:status].to_i == 0
    #   @user.enabled!
    # end
    @user.enabled!
    redirect_to admin_users_path, notice: "User re-enabled successfully."
  end

  private def set_user
    @user = User.find(params[:id])
  end
end
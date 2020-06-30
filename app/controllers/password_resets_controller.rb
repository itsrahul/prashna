class PasswordResetsController < ApplicationController
  skip_before_action :authorize, only: [:new, :create, :edit, :update]

  def new
  end

  def create
    user = User.find_by_email(params[:email])
    user.send_reset_link if user
    redirect_to root_path, notice: 'Reset link will be sent to your email!'
  end

  def edit
    @user = User.find_by_reset_token(params[:token])
    unless @user
      redirect_to root_path, notice: 'Invalid Link' and return
    end
  end

  def update
    @user = User.find_by(id: params[:id], reset_token: params[:token])
    debugger
    if @user.reset_token_expire < Time.current
      redirect_to password_resets_new_path, notice: "Password reset link has expired." and return
    end
    if @user.update(password_reset_params)
      @user.update_columns(reset_token: nil)
      redirect_to root_path, notice: "Password has been reset."
    else
      render :edit
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def password_reset_params
    params.require(:user).permit(:password, :password_confirmation)
  end

end

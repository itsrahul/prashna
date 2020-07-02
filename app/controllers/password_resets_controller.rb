class PasswordResetsController < ApplicationController
  skip_before_action :authorize, only: [:new, :create, :edit, :update]

  def new
  end

  def create
    user = User.find_by_email(params[:email])

    if user
      user.send_reset_link
    end

    redirect_to root_path, notice: t('.link_sent')
  end

  def edit
    #FIXME_AB: before action find_user_by_reset_token
    @user = User.find_by_reset_token(params[:token])
    unless @user
      redirect_to root_path, notice: t('.invalid') and return
    end
  end

  def update
    @user = User.find_by(reset_token: params[:token])
    #FIXME_AB: this condition should be extracted as before_action validate_reset_token and used for edit and update both
    if @user.reset_token_expire < Time.current
      redirect_to password_resets_new_path, notice: t('.link_expired') and return
    end
    if @user.update(password_reset_params)
      @user.update_columns(reset_token: nil)
      #FIXME_AB: reset time also. @user.clear_password_reset_fields
      redirect_to root_path, notice: t('.success')
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

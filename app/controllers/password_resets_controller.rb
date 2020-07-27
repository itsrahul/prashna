class PasswordResetsController < ApplicationController
  skip_before_action :authorize, only: [:new, :create, :edit, :update]
  before_action :find_user_by_reset_token, only: [:edit, :update]
  before_action :validate_reset_token, only: [:edit, :update]

  def new
  end

  def create
    if params[:email].blank?
      redirect_to password_resets_new_path, notice: t('.empty') and return
    end

    user = User.enabled.find_by_email(params[:email])

    if user
      user.send_reset_link
    end

    redirect_to root_path, notice: t('.link_sent')
  end

  def edit
  end

  def update
    if @user.update(password_reset_params)
      @user.clear_password_reset_fields
      redirect_to root_path, notice: t('.success')
    else
      render :edit
    end
  end

  private def find_user_by_reset_token
    @user = User.enabled.find_by_reset_token(params[:token])
    if not @user
      redirect_to root_path, notice: t('.invalid') and return
    end
  end

  private def validate_reset_token
    if @user.reset_token_expire < Time.current
      redirect_to password_resets_new_path, notice: t('.link_expired') and return
    end
  end


  private def password_reset_params
    params.require(:user).permit(:password, :password_confirmation)
  end

end

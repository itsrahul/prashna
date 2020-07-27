class SessionsController < ApplicationController
  skip_before_action :authorize, only: [:new, :create]
  before_action :get_user_from_cookie, only: [:new, :create]

  def new
  end

  def create
    user = User.verified.find_by(email: params[:email])
    
    if user.disabled?
      redirect_to login_url, alert: t('.user_disabled')
      return
    end

    if not User.enabled.where(email: params[:email]).exists?
      redirect_to login_url, alert: t('.no_user_found')
      return
    end
    if not user.verified?
      redirect_to login_url, alert: t('.unverified')
      return
    end

    if user.try(:authenticate, params[:password])
      session[:user_id] = user.id
      if params[:remember_me]
        set_remember_me(user.id) 
      end
      redirect_to root_path
    else
      redirect_to login_url, alert: t(".invalid_credentials")
    end
  end

  def destroy
    reset_session
    reset_remember_me
    redirect_to root_path, notice: t('.logout')
  end

  private def set_remember_me(id)
    cookies.signed.permanent[:user_id] = id
  end

  private def reset_remember_me
    cookies.delete(:user_id)
  end

  private def get_user_from_cookie
    session[:user_id] = cookies.signed[:user_id]
    if session[:user_id]
      redirect_to root_path
    end
  end

end

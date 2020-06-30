class SessionsController < ApplicationController
  skip_before_action :authorize, only: [:new, :create]
  before_action :get_user_from_cookie, only: [:new, :create]
 
  def new
  end

  def create
    user = User.find_by(name: params[:name])
    
    if user.verification_at.nil?
      redirect_to login_url, alert: "Please verify your account to login" and return
    end
    
    if user.try(:authenticate, params[:password])
      session[:user_id] = user.id
      set_remember_me(user.id) if params[:remember_me]
      redirect_to users_url
    else
      redirect_to login_url, alert: "Invalid user/password combination"
    end
  end

  def destroy
    session[:user_id] = nil
    # reset_session
    reset_remember_me
    redirect_to users_url, notice: "Logged out"
  end

  private 
    def set_remember_me(id)
      cookies.signed.permanent[:user_id] = id
    end

    def reset_remember_me
      cookies.delete(:user_id)
    end

    def get_user_from_cookie
      session[:user_id] = cookies.signed[:user_id]
      redirect_to users_url if session[:user_id]
    end

    def check_verified(user)
      user.verification_at
    end
end

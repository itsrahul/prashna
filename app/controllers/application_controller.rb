class ApplicationController < ActionController::Base
  before_action :authorize
  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    current_user != nil
  end

  protected def authorize
    unless current_user
      redirect_to login_url, notice: t('.login_required')
    end
  end
end

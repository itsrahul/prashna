class ApplicationController < ActionController::Base
  before_action :authorize, :fetch_notification
  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= User.enabled.find_by(id: session[:user_id])
  end

  def logged_in?
    current_user != nil
  end

  def fetch_notification
    if logged_in?
      @notifications = current_user.notifications
    end
  end

  protected def authorize
    if not current_user
      redirect_to login_url, notice: t('.login_required')
    end
  end
end

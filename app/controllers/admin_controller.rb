#done FIXME_AB: ActionController::Base
class AdminController < ApplicationController
  before_action :ensure_user_is_admin
  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= User.enabled.find_by(id: session[:user_id])
  end
  
  def ensure_user_is_admin
    unless current_user.admin?
      redirect_to root_path, notice: t('.not_admin')
    end
  end
end

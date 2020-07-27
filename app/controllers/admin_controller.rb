#FIXME_AB: ActionController::Base
class AdminController < ApplicationController
  before_action :ensure_user_is_admin

  def ensure_user_is_admin
    unless current_user.admin?
      redirect_to root_path, notice: "You don't have privilege to access this section"
    end
  end
end

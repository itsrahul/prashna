class NotificationsController < ApplicationController
  def index
    @notifications = Notification.where(user: current_user).limit(3)
  end
end

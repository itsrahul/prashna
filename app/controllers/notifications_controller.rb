class NotificationsController < ApplicationController
  def index
    notifications = current_user.notifications.unread
    render json: { count: notifications.count, items: notifications }
  end

  def open
    notification = Notification.find(params[:format])
    if notification.unread?
      notification.mark_read
    end
    redirect_to question_path(notification.notifiable_id)
  end
end

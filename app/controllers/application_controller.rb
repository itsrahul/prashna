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

  private def set_topics(object, list)
    topic_list = []
    list.strip.split(/,\s*/).each do |term|
      topic_list << Topic.find_or_initialize_by(name: term.capitalize)
    end
    object.topics = topic_list
  end

end

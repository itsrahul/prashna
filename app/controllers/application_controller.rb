class ApplicationController < ActionController::Base

  #FIXME_AB: lets start using I18n. Instead of entering all translation in one single config/local/en.yml lets do directory based.
  #FIXME_AB: config/locales/model/user.yml
  #FIXME_AB: config/locales/model/user.yml


  #FIXME_AB: git remove database.yml, add to .gitignore
  #FIXME_AB: add example file to git. config/database.yml.example

  before_action :authorize
  helper_method :current_user, :logged_in?

  def current_user
    #FIXME_AB: see authorize
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    current_user != nil
  end

  protected
    def authorize
      #FIXME_AB:       unless (@current_user = User.find_by(id: session[:user_id]))
      unless User.find_by(id: session[:user_id])
        redirect_to login_url, notice: I18n.t('.unauthorized_message')
      end
    end
end

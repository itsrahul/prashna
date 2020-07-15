class HomeController < ApplicationController
  skip_before_action :authorize

  def index
    #FIXME_AB: update required keys and application.yml.example for page_size env variable
    @questions = Question.published.includes(:user, {answers: [:user, {comments: [:user]} ]}, {comments: [:user]} ).paginate(page: params[:page], per_page: ENV['pagination_size'].to_i).order(updated_at: :desc)
  end
end

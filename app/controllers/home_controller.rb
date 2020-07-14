class HomeController < ApplicationController
  # skip_before_action :authorize

  def index
    @questions = Question.published.includes(:user, {answers: [:user, {comments: [:user]} ]}, {comments: [:user]} ).paginate(page: params[:page], per_page: ENV['pagination_size'].to_i).order(updated_at: :desc)
    #FIXME_AB: show paginated list. number of questions per page should come from env
  end 
end

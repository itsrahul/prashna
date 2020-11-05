class HomeController < ApplicationController
  skip_before_action :authorize

  def index
    @questions = Question.published.includes(:user, :doc_attachment, {comments: [:user]}, {answers: [:user, :comments]}, :topics  ).paginate(page: params[:page], per_page: ENV['pagination_size'].to_i).order(published_at: :desc)
  end

  def refresh
    questions_count = Question.published.since(params[:time]).count
    render json: {count: questions_count}
  end

end

class SearchController < ApplicationController
  skip_before_action :authorize
  
  def search
    questions = Question.published.search_by_title(params[:title]).order(updated_at: :desc)
    @questions = questions.includes([:topics]).paginate(page: params[:page], per_page: ENV['pagination_size'].to_i)
    if @questions.blank?
      redirect_to root_path, notice: t('.invalid')
    end
  end

  def topics
    if (topic = Topic.find_by(name: params[:name]) )
      @questions = topic.questions.published.paginate(page: params[:page], per_page: ENV['pagination_size'].to_i).order(published_at: :desc)
    else
      redirect_to root_path, notice: t('.invalid')
    end
  end

  def user
    if (@user = User.enabled.find_by(id: params[:id]) )
      @questions = @user.questions.published.includes(:doc_attachment, :topics, {comments: [:user]}, { answers: [:user, :comments ] }).paginate(page: params[:page], per_page: ENV['pagination_size'].to_i).order(published_at: :desc)
    else
      redirect_to root_path, notice: t('.invalid')
    end
  end

end
# /search/topics/ruby
# /search/term/searchterm
# /search/user/3
class SearchController < ApplicationController
  def search
    questions = Question.published.search_by_title(params[:title]).order(updated_at: :desc)
    @questions = questions.includes([:topics]).paginate(page: params[:page], per_page: ENV['pagination_size'].to_i)
    if @questions.blank?
      redirect_to root_path, notice: "No questions found"
    end
  end

  def topics
    if (topic = Topic.find_by(name: params[:name]) )
      @questions = topic.questions.published.paginate(page: params[:page], per_page: ENV['pagination_size'].to_i)
    else
      redirect_to root_path, notice: "No topic found"
    end
  end

  def user
    if (user = User.find_by(id: params[:id]) )
      @questions = user.questions.published.paginate(page: params[:page], per_page: ENV['pagination_size'].to_i)
    else
      redirect_to root_path, notice: "No questions found"
    end
  end

end
# /search/topics/ruby
# /search/term/searchterm
# /search/user/3
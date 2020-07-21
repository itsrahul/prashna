class TopicsController < ApplicationController
  def search
    topics = Topic.search(params[:q]).map { |t| { id: t.id, label: t.name } }
    render json: topics
  end

  def show
  end

  def index
    if (topic = Topic.find_by(name: params[:name]) )
      @questions = topic.questions.published.paginate(page: params[:page], per_page: ENV['pagination_size'].to_i)
    else
      redirect_to root_path, notice: t('.invalid')
    end
  end
  
end

class TopicsController < ApplicationController
  def search
    topics = Topic.search(params[:q]).map { |t| { id: t.id, label: t.name } }
    render json: topics
  end

  def show
  end
end

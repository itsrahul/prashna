class HomeController < ApplicationController
  skip_before_action :authorize
  def index
    @questions = Question.published.order(updated_at: :desc)
  end
end

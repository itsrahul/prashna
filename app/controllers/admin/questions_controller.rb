class Admin::QuestionsController < AdminController
  before_action :set_question, only: [:show]
  def index
    @questions = Question.unscoped.paginate(page: params[:page], per_page: ENV['admin_pagination_size'].to_i)
  end

  def show
    # @question
  end

  def edit
  end

  private def set_question
    @question = Question.find(params[:id])
  end
end
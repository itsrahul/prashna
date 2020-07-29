class Admin::QuestionsController < AdminController
  before_action :set_question, only: [:show, :unpublish]
  def index
    @questions = Question.unscoped.paginate(page: params[:page], per_page: ENV['admin_pagination_size'].to_i)
  end

  def show
    # @question
  end

  def unpublish
    @question.update_columns(abuse_status: 1)
    redirect_to admin_questions_path , notice: "Unpublished successfully."
  end

  def edit
  end

  private def set_question
    @question = Question.unscoped.find(params[:id])
  end
end
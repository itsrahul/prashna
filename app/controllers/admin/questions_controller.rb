class Admin::QuestionsController < AdminController
  before_action :set_question, only: [:show, :unpublish]
  def index
    @questions = Question.unscoped.paginate(page: params[:page])
  end

  def show
  end

  def unpublish
    @question.mark_abused!
    redirect_to admin_questions_path , notice: "Unpublished successfully."
  end

  def edit
  end

  private def set_question
    @question = Question.unscoped.find(params[:id])
  end
end
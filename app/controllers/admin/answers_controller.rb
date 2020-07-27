class Admin::AnswersController < AdminController
  before_action :set_answer, only: [:show, :unpublish]
  before_action :set_question, only: [:index]

  def index
    @answers = Answer.unscoped.where(question: @question).includes(:user, :question)
  end

  def show
  end

  def unpublish
    @answer.abused!
    redirect_to admin_question_answers_path(@answer.question.id), notice: "unpublished successfully."
    # @answer.destroy
  end

  private def set_answer
    @answer = Answer.unscoped.find(params[:id])
  end

  private def set_question
    @question = Question.unscoped.find(params[:question_id])
  end

end
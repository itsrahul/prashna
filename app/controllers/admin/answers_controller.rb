class Admin::AnswersController < AdminController
  #done FIXME_AB: lets have different admin layout for all admin controllers with navbar having admin specific links.
  before_action :set_answer, only: [:show, :unpublish]
  before_action :set_question, only: [:index]

  def index
    @answers = Answer.unscoped.where(question: @question).includes(:user, :question).paginate(page: params[:page])
  end

  def show
  end

  def unpublish
    @answer.abused!
    redirect_to admin_question_answers_path(@answer.question.id), notice: "unpublished successfully."
  end

  private def set_answer
    @answer = Answer.unscoped.find(params[:id])
  end

  private def set_question
    @question = Question.unscoped.find(params[:question_id])
  end

end

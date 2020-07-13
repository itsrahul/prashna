class AnswersController < ApplicationController
  before_action :set_question

  def create
    answer = @question.answers.create(user: current_user, content:  params[:content])
    @answers = @question.answers
    if @answers
      render partial: "shared/answers"
    end
  end

  private def set_question
    unless (@question = Question.published.find(params[:question_id]))
      redirect_to root_path, notice: "no question for answer"
    end
  end

  private def answer_params
    # params.require(:answer).permit(:content)
  end

end

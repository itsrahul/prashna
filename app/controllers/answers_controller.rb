class AnswersController < ApplicationController
  before_action :set_question

  def create
    answer = @question.answers.create(user: current_user, content:  params[:content])
    UserMailer.answer_posted_mail(@question.user.id, @question.id).deliver_later
    @answers = @question.answers
    if @answers
      render partial: "shared/answers"
    end
  end

  private def set_question
    if not (@question = Question.published.find(params[:question_id]))
      redirect_to root_path, alert: t('.not_found')
    end
  end

end

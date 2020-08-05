class QuestionsController < ApplicationController
  skip_before_action :authorize

  before_action :set_question, only: [:edit, :update, :destroy]
  before_action :ensure_not_published, only: [:update, :destroy]
  before_action :ensure_not_abused, only: [:update, :destroy]
  before_action :ensure_credit_balance, only: [:new, :create]

  def index
    @questions = Question.unscoped.where(user: current_user).paginate(page: params[:page], per_page: ENV['pagination_size'].to_i).order(updated_at: :desc)
  end

  def follower
    #TODO: get user_followers -> questions.. # {answers: [:user, {comments: [:user]}]} ??
    @questions = Question.published.where(user: current_user.users_followed.includes(:followed).collect(&:followed) ).includes(:user, {comments: [:user]}).paginate(page: params[:page], per_page: ENV['pagination_size'].to_i)
  end

  def new
    @question = Question.new
  end

  def edit
  end

  def show
    @questions = Question.unscoped.where(id: params[:id])
    if @questions.first.abused?
      redirect_to root_path, alert: "Question has been reported abused."
      return
    end
    if @questions.blank?
      redirect_to root_path, alert: "Invalid question id"
      return
    end
    if not @questions.first.published?
      redirect_to questions_path, alert: "Question is not published yet."
      return
    end
  end

  def create
    if save_as_draft
      @question = current_user.questions.unabused.draft.build(question_params)
    else
      @question = current_user.questions.unabused.published.build(question_params)
    end

    respond_to do |format|
      @question.set_topics(params[:question][:topic])
      if @question.save
        @question.publish if @question.published?
        format.html { redirect_to @question, notice: t('.success') }
        format.json { render :show, status: :created, location: @question }
      else
        format.html { render :new }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @question.set_topics(params[:question][:topic])
    respond_to do |format|
      if @question.update(question_params)
        if not save_as_draft
          if not @question.status_was == "published"
            @question.update_columns(status: "published")
            @question.publish
          end
        end
        format.html { redirect_to questions_url, notice: t('.success') }
        format.json { render :show, status: :ok, location: @question }
      else
        format.html { render :edit }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @question.destroy
        format.html { redirect_to questions_url, notice: t('.success') }
        format.json { head :no_content }
      else
        format.html { redirect_to root_path, notice: t('.failure') }
      end
    end
  end

  private def save_as_draft
    params[:commit] == "Save as Draft"
  end

  private  def set_question
    #done FIXME_AB: add a callback before_update to check whether question is in published state.
    if not (@question = current_user.questions.draft.find_by(id: params[:id]))
      redirect_to questions_path, notice: t('.too_late')
    end
  end

  private def question_params
    params.require(:question).permit(:title, :content, :doc)
  end

  private def ensure_credit_balance
    #done FIXME_AB: user.has_sufficient_credits_to_post_question? => true / false
    if not current_user.has_sufficient_credits_to_post_question?
      redirect_to questions_path, notice: t('.low_balance')
    end
  end

  private def ensure_not_published
    # change name and condition to until answered/commment/votes
    if @question.published?
      redirect_to questions_path, notice: t('.too_late')
    end
  end

  private def ensure_not_abused
    if  @question.abused?
      redirect_to questions_path, notice: t('.abused_q')
    end
  end
end

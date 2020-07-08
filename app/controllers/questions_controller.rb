class QuestionsController < ApplicationController

  before_action :set_question, only: [:show, :edit, :update, :destroy]
  before_action :ensure_not_published, only: [:destroy]
  #FIXME_AB: add :new also

  before_action :ensure_credit_balance, only: [:create]

  def index
    #FIXME_AB: eagerload associations whver possible
    #FIXME_AB: use bullet gem
    @questions = current_user.questions
    #FIXME_AB: paginated
  end

  def new
    @question = Question.new
  end

  def edit
  end

  #FIXME_AB: lets move to search controller
  def search
    @questions = Question.search_by_title(params[:search])
    if @questions.exists?
      render partial: "questions"
    else
      render json: false
    end

  end

  def create
    if save_as_draft
      @question = current_user.questions.draft.build(question_params)
    else
      @question = current_user.questions.published.build(question_params)
    end


    respond_to do |format|
      if @question.save
        set_topics(@question, params[:question][:topic])
        format.html { redirect_to @question, notice: t('.success') }
        format.json { render :show, status: :created, location: @question }
      else
        format.html { render :new }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    set_topics(@question, params[:question][:topic])

    respond_to do |format|
      if @question.update(question_params)
        unless save_as_draft
          @question.published!
        end
        format.html { redirect_to @question, notice: t('.success') }
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

  #FIXME_AB: private
  def save_as_draft
    params[:commit] == "Save as Draft"
  end

  private  def set_question
    #FIXME_AB: current_user.questions.draft.find
    #FIXME_AB: add a callback before_update to check whether question is in published state.
    unless (@question = Question.find_by(id: params[:id]))
      redirect_to root_path, notice: t('.invalid')
    end
  end

  private def question_params
    params.require(:question).permit(:title, :content)
  end

  private def ensure_credit_balance
    #FIXME_AB: take credits required for question posting from env.
    #FIXME_AB: validation in model, before create. check credit balance
    if current_user.credits < 1
      redirect_to questions_path, notice: t('.low_balance')
    end
  end

  private def ensure_not_published
    # change name and condition to until answered/commment/votes
    if @question.published?
      redirect_to questions_path, notice: t('.too_late')
    end
  end
end

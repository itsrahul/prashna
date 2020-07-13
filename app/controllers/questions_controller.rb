class QuestionsController < ApplicationController

  before_action :set_question, only: [:edit, :update, :destroy]
  before_action :ensure_not_published, only: [:update, :destroy]
  #FIXME_AB: add :new also

  before_action :ensure_credit_balance, only: [:new, :create]

  def index
    #FIXME_AB: eagerload associations whver possible
    #FIXME_AB: use bullet gem
    @questions = current_user.questions.paginate(page: params[:page], per_page: ENV['pagination_size'].to_i)
    #FIXME_AB: paginated
  end

  def new
    @question = Question.new
  end

  def edit
  end

  def show
    @question = Question.published.find_by(id: params[:id])
  end
  #FIXME_AB: lets move to search controller
  def search
  end

  def create
    if save_as_draft
      @question = current_user.questions.draft.build(question_params)
    else
      @question = current_user.questions.published.build(question_params)
      #create notification, charge 1 credit
      @question.notify_question_pubished(current_user)
      @question.charge_credits(current_user)
    end

    respond_to do |format|
      if @question.save
        @question.set_topics(params[:question][:topic])
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
        unless save_as_draft
          @question.update_columns(status: "published")
          #create notification, charge 1 credit
          @question.notify_question_pubished(current_user)
          @question.charge_credits(current_user)
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

  #FIXME_AB: private
  private def save_as_draft
    params[:commit] == "Save as Draft"
  end

  private  def set_question
    #FIXME_AB: current_user.questions.draft.find
    #FIXME_AB: add a callback before_update to check whether question is in published state.
    unless (@question = current_user.questions.draft.find_by(id: params[:id]))
      redirect_to questions_path, notice: t('.too_late')
    end
  end

  private def question_params
    params.require(:question).permit(:title, :content, :doc)
  end

  private def ensure_credit_balance
    #FIXME_AB: take credits required for question posting from env.
    #FIXME_AB: validation in model, before create. check credit balance
    if current_user.credits < ENV['credit_for_question_post'].to_i
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

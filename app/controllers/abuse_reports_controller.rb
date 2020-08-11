class AbuseReportsController < ApplicationController
  before_action :set_abusable

  def new
    @abuse = current_user.abuse_reports.find_or_initialize_by(abusable: @abusable)
    @abuse.reason = params[:reason]
    if @abuse.save
      render json: { success: "#{@abusable.class}#{t('.success')}"}
    else
      render json: { failure: @abuse.errors.full_messages.join(', ') }
    end
  end

  def create
  end

  private def set_abusable
    if params[:abusable] == 'question'
      @abusable = Question.find(params[:id])
    elsif params[:abusable] == 'answer'
      @abusable = Answer.find(params[:id])
    elsif params[:abusable] == 'comment'
      @abusable = Comment.find(params[:id])
    end
  end

end

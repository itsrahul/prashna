class AbuseReportsController < ApplicationController
  before_action :set_abusable

  def new
    @abuse = current_user.abuse_reports.find_or_initialize_by(abusable: @abusable)
    @abuse.reason = params[:reason]

    # @abuse = current_user.abuse_reports.new(abusable: @abusable, reason: params[:reason])
    if @abuse.save
      # notice = "#{@abusable.class}: \"#{@abusable.title}\" #{t('.success')}"
      render json: { success: "#{@abusable.class}: \"#{@abusable.title}\" #{t('.success')}"}
    else
      # notice = @abuse.errors.full_messages.join(', ')
      render json: { failure: @abuse.errors.full_messages.join(', ') }
    end
  end

  def create
    # @abuse   = current_user.abuse_reports.new(abusable: @abusable, reason: abuse_params[:reason])
    # if @abuse.save
    #   redirect_to root_path, notice: "#{@abusable.class}: \"#{@abusable.title}\" #{t('.success')}"
    # end
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

  # private def abuse_params
  #   params.require(:abuse_report).permit(:reason)
  # end
end

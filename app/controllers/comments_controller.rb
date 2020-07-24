class CommentsController < ApplicationController
  before_action :set_commentable
  def create
    comment = Comment.create(user: current_user, content:  params[:content], commentable: @commentable)
    @comments = @commentable.comments
    if @comments
      render partial: "shared/comments"
    end
  end

  private def set_commentable
    if params[:answer_id]
      @commentable = Answer.find(params[:answer_id])
    else
      @commentable = Question.published.find(params[:question_id])
    end
    
  end

end
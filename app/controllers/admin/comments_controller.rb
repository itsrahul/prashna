class Admin::CommentsController < AdminController
  before_action :set_comment, only: [:show, :unpublish]
  before_action :set_commentable, only: [:index]

  def index
    @comments = @commentable.comments
  end

  def unpublish
    @comment.abused!
    redirect_to admin_question_comments_path(@comment.commentable_id), notice: "unpublished successfully."
    # @comment.destroy
  end

  private def set_comment
    @comment = Comment.unscoped.find(params[:id])
  end

  private def set_commentable
    if params[:answer_id]
      @commentable = Answer.unscoped.find(params[:answer_id])
    else
      @commentable = Question.unscoped.find(params[:question_id])
    end
  end
end
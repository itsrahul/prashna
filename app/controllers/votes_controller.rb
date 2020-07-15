class VotesController < ApplicationController
  before_action :set_votable

  def create
    @vote = Vote.find_or_initialize_by(votable: @votable, user: current_user)
    if params[:format]
      @vote.up_vote!
    else
      @vote.down_vote!
    end
    # implement ajax properly
    # send up/down votes for answer/comment i.e votable to update vote count
    render json: { upcount: Vote.upvote_count(@votable), downcount: Vote.downvote_count(@votable) }
  end

  private def set_votable
    if params[:answer_id]
      @votable = Answer.find(params[:answer_id])
    else
      @votable = Comment.find(params[:comment_id])
    end
  end
end

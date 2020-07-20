class VotesController < ApplicationController
  before_action :set_votable

  def create
    @vote = Vote.find_or_initialize_by(votable: @votable, user: current_user)
    if params[:format]
      if @vote.down_vote? && @vote.created_at?
        @vote.destroy
      else
        @vote.down_vote!
      end
    else
      if @vote.up_vote? && @vote.created_at?
        @vote.destroy
      else
        @vote.up_vote!
      end
    end
    #TODO: implement ajax properly
    #TODO: send up/down votes for answer/comment i.e votable to update vote count
    render json: { upcount: Vote.by_votable(@votable).up_vote.count, downcount: Vote.by_votable(@votable).down_vote.count }
  end

  private def set_votable
    if params[:answer_id]
      @votable = Answer.find(params[:answer_id])
    else
      @votable = Comment.find(params[:comment_id])
    end
  end
end

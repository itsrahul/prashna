class FollowersController < ApplicationController
  before_action :set_user, only: [:create, :index]

  def create
    # user = User.find(params[:id]) 
    follow_record = UserFollower.find_or_initialize_by(follower: current_user, followed: @user)
    if params[:state].to_i.zero?
      follow_record.destroy
      # user.followers.delete(current_user)
    else
      follow_record.save
      # user.followers << current_user
    end
    #TODO: change it according to UserFollower
    #TODO: change follow.js as well.
    render json: { follower_count: @user.followed_by.count}
  end

  def index
    # debugger
    render json: UserFollower.where(follower: current_user, followed: @user).exists?
  end
  
  private def set_user
    @user = User.find(params[:id])
  end
end
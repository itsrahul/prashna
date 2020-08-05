class FollowersController < ApplicationController
  before_action :set_user, only: [:create, :index]

  def create
    follow_record = UserFollower.find_or_initialize_by(follower: current_user, followed: @user)
    if params[:state].to_i.zero?
      follow_record.destroy
    else
      follow_record.save
    end
    render json: { follower_count: @user.followed_by.count}
  end

  def index
    render json: UserFollower.where(follower: current_user, followed: @user).exists?
  end
  
  private def set_user
    @user = User.enabled.find(params[:id])
  end
end
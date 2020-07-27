#FIXME_AB: read about ruby module nesting
# module Api
#   class FeedController
#   end
# end

class Api::FeedController < ApiController
  before_action :set_user, only: [:index]

  def index
    # /api/feed.json?token=bno7HWG3fUUKAkjTtlZ3WQ
    # questions belongs to topics I follow, including comments and answers.
    @questions = @user.topics.includes([{questions: [:user, {answers: [:user]}, :comments]}]).collect_concat(&:questions)
  end

  #FIXME_AB: move this to ApiController as authorize
  private def set_user
    if not (@user = User.find_by_auth_token(params[:token]))
      render json: { error: "Invalid auth token"}
    end
    # if not @user == current_user
    #   render json: { error: "Invalid auth token"}
    # end
  end
end

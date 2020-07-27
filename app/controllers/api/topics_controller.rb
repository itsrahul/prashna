class Api::TopicsController < ApiController
  before_action :ensure_limited_requests, only: [:show]
  before_action :set_topic, only: [:show]

  def show
    #FIXME_AB: eager load
    @questions =  @topic.questions.order(updated_at: :desc).limit(ENV['public_api_requests_question_limit'].to_i)
    #FIXME_AB: make a after_action and move it there, in ApiController
    ApiRequest.create(address: request.ip)
  end

  private def set_topic
    if not (@topic = Topic.find_by_name(params[:id]))
      render json: { error: "No such topic found"}
    end
  end

  #FIXME_AB: we may need this in other controllers if we expose further public api endpoints so lets move it to ApiController
  private def ensure_limited_requests
    if ApiRequest.where(address: request.ip).in_last_hours(ENV['public_api_requests_time_limit'].to_i).count >= ENV['public_api_requests_request_limit'].to_i
      render json: { error: "Too many request, try after some time."}
    end
  end
end

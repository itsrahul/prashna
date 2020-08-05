module Api
  class TopicsController < ApiController
    skip_before_action :authorize_user_token
    before_action :set_topic, :ensure_limited_requests, only: [:show]
    after_action :create_request_record, only: [:show]

    def show
      #FIXME_AB: eager load
      @questions =  @topic.questions.order(updated_at: :desc).limit(ENV['public_api_requests_question_limit'].to_i)
      #done FIXME_AB: make a after_action and move it there, in ApiController
    end

    private def set_topic
      if not (@topic = Topic.find_by_name(params[:id]))
        render json: { error: "No such topic found"}
      end
    end
  end
end
class ApiController < ActionController::Base
  #done FIXME_AB: inherit from ActionController::Base
  before_action :authorize

  #done FIXME_AB: move this to ApiController as authorize
  protected def authorize
    if not (@user = User.find_by_auth_token(params[:token]))
      render json: { error: "Invalid auth token"}
    end
  end

  #done FIXME_AB: we may need this in other controllers if we expose further public api endpoints so lets move it to ApiController
  protected def ensure_limited_requests
    if ApiRequest.where(address: request.ip).in_last_hours(ENV['public_api_requests_time_limit'].to_i).count >= ENV['public_api_requests_request_limit'].to_i
      render json: { error: "Too many request, try after some time."}
    end
  end

  protected def create_request_record
    ApiRequest.create(address: request.ip)
  end
end

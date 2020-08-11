class ApiController < ActionController::Base
  #done FIXME_AB: inherit from ActionController::Base
  before_action :authorize_user_token

  #done FIXME_AB: move this to ApiController as authorize
  protected def authorize_user_token
    if not (@user = User.find_by_auth_token(params[:token]))
      render json: { error: t('.invalid_auth')}
    end
  end

  #done FIXME_AB: we may need this in other controllers if we expose further public api endpoints so lets move it to ApiController
  protected def ensure_limited_requests
    if ApiRequest.where(address: request.ip).in_last_hours(ENV['public_api_requests_time_limit'].to_i).count >= ENV['public_api_requests_request_limit'].to_i
      render json: { error: t('.too_many_requests')}
    end
  end

  protected def create_request_record
    ApiRequest.create(address: request.ip)
  end
end

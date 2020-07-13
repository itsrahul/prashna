class HomeController < ApplicationController
  # skip_before_action :authorize

  def index
    @questions = Question.published.includes([:topics]).paginate(page: params[:page], per_page: ENV['pagination_size'].to_i).order(updated_at: :desc)
    #done FIXME_AB: show paginated list. number of questions per page should come from env
  end
end

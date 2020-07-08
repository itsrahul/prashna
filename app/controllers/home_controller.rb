class HomeController < ApplicationController
  skip_before_action :authorize

  def index
    @questions = Question.published.order(updated_at: :desc)
    #FIXME_AB: show paginated list. number of questions per page should come from env
  end
end

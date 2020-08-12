#done FIXME_AB: read about ruby module nesting
module Api
  class FeedController < ApiController

    def index
      # /api/feed.json?token=bno7HWG3fUUKAkjTtlZ3WQ
      @questions = @user.topics.includes([{questions: [:user, {answers: [:user]}, :comments]}]).collect_concat(&:questions).uniq
    end

  end
end
class SearchQuestionsController < ApplicationController
  def search
    all_q = Question.published.order(updated_at: :desc)
    questions = all_q.search_by_title(params[:search])
    unless questions.exists?
      tp = Topic.where(name: params[:search])
      if tp.present?
        # @questions += all_q.joins(:topics).where(topics: { id: tp.ids })
        questions = all_q.joins(:topics).where(topics: { id: tp.ids })
      end
    end
    @questions = questions.includes([:topics]).paginate(page: params[:page], per_page: ENV['pagination_size'].to_i)
    if @questions.exists?
      render partial: "shared/questions"
    else
      render json: false
    end
  end
end

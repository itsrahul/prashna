class QuestionPresenter < ApplicationPresenter
  presents :question

  # Methods delegated to Presented Class Question object's question
  @delegation_methods = [:content, :published_at]

  delegate *@delegation_methods, to: :question

  # Start the methods
  def markdown_content
    options = [:hard_Wrap, :autolink, :no_intra_emphasis, :fenced_code_blocks]
    Markdown.new(content, *options).to_html.html_safe
  end

  def published_ago
    time_diff = (Time.current - published_at)
    if (time_diff / 1.minute).round < 60
      return "#{(time_diff / 1.minute).round} minutes"
    elsif (time_diff / 1.hour).round < 24
      return "#{(time_diff / 1.hour).round} hours"
    else
      return "#{(time_diff / 1.day).round} days"
    end
  end
end

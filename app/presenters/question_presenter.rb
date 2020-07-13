class QuestionPresenter < ApplicationPresenter
  presents :question

  # Methods delegated to Presented Class Question object's question
  @delegation_methods = [:content]

  delegate *@delegation_methods, to: :question

  # Start the methods
  def markdown_content
    options = [:hard_Wrap, :autolink, :no_intra_emphasis, :fenced_code_blocks]
    Markdown.new(content, *options).to_html.html_safe
  end
end

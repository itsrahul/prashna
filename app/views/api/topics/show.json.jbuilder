#FIXME_AB: remove status
#FIXME_AB: make it a partial and use at both places
#FIXME_AB: lets include upvotes and downvotes
json.questions @questions do |question|
  json.title question.title
  json.by question.user.name
  # json.content question.markdown_content
  json.status question.status
  # json.topics question.topics, :name
  json.answers question.answers do |answer|
    json.user answer.user.name
    json.content answer.content
    # json.comments_count answer.comments_count
  end
  json.comments question.comments do |comment|
    json.user comment.user.name
    json.content comment.content
  end
end

json.questions @questions do |question|
  json.title question.title
  json.by question.user.name
  json.status question.status
  json.answers question.answers do |answer|
    json.user answer.user.name
    json.content answer.content
  end
  json.comments question.comments do |comment|
    json.user comment.user.name
    json.content comment.content
  end
end
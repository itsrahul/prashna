#FIXME_AB: make it a partial and use at both places
json.questions @questions do |question|
  json.title question.title
  json.by question.user.name
  #FIXME_AB: remove status
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

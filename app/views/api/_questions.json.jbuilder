#done FIXME_AB: remove status
#done FIXME_AB: lets include upvotes and downvotes
json.questions questions do |question|
  json.title question.title
  json.by question.user.name
  json.answers question.answers do |answer|
    json.user answer.user.name
    json.content answer.content
    json.upvote_count answer.votes.up_vote.count
    json.downvote_count answer.votes.down_vote.count
  end
  json.comments question.comments do |comment|
    json.user comment.user.name
    json.content comment.content    
    json.upvote_count comment.votes.up_vote.count
    json.downvote_count comment.votes.down_vote.count
  end
end
json.array!(@comments) do |comment|
  json.extract! comment, :id, :parent_id, :todo_id, :user_id, :content, :deleted
  json.url comment_url(comment, format: :json)
end

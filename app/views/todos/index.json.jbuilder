json.array!(@todos) do |todo|
  json.extract! todo, :id, :title, :creator_id, :assign_user_id, :deadline
  json.url todo_url(todo, format: :json)
end

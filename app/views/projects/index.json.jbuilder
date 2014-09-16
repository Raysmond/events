json.array!(@projects) do |project|
  json.extract! project, :id, :team_id, :user_id, :name, :description
  json.url project_url(project, format: :json)
end

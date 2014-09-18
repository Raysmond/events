# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user = User.create!(:name => 'a用户', :email => "a@a.com", :password => '111')
user1 = User.create!(:name => 'b用户', :email => "b@b.com", :password => '111')
user2 = User.create!(:name => 'c用户', :email => "c@c.com", :password => '111')
team = Team.create!(name: "Tower开发团队", creator_id: user.id)
TeamsUser.create(user_id: user.id, team_id: team.id)
TeamsUser.create(user_id: user1.id, team_id: team.id)
TeamsUser.create(user_id: user2.id, team_id: team.id)
user.update_attribute(:current_team_id, team.id)
user1.update_attribute(:current_team_id, team.id)
user2.update_attribute(:current_team_id, team.id)

project1 = Project.create!(name: "产品网站", team_id: team.id, user_id: user.id) 
project2 = Project.create!(name: "微信开发", team_id: team.id, user_id: user.id) 

Access.create!(user_id: user.id, project_id: project1.id)
Access.create!(user_id: user.id, project_id: project2.id)
Access.create!(user_id: user1.id, project_id: project1.id)
Access.create!(user_id: user1.id, project_id: project2.id)
Access.create!(user_id: user2.id, project_id: project1.id)
Access.create!(user_id: user2.id, project_id: project2.id)
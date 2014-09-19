class EventsController < ApplicationController
	before_action :authenticate_user!
	
	# GET /events
	# 显示当前登录用户的当前团队内的动态
	# 显示登录用户有权限查看到的项目的动态，没有权限的不显示
	def index
		@events = Event.where(team_id: current_user.current_team_id).order(created_at: :desc).page(params[:page]).per(5)
		
		accessable_projects = Access.where(user_id: current_user.id).joins(:project).where("projects.team_id = ?", current_user.current_team_id)
		accessable_projects_ids = []
		accessable_projects.each do |p|
			accessable_projects_ids.push p.id
		end

		# 先只考虑用户访问权限内的Project，日历不管先
		@events = @events.where("(ownerable_id in (?) AND ownerable_type = ?) OR (ownerable_type <> ?)", accessable_projects_ids, 'Project', 'Project') 

	end

end
class Event < ActiveRecord::Base
	extend Enumerize

	belongs_to :eventable, polymorphic: true
	belongs_to :user

	# 事件动作 or 类型
	enumerize :action, in: {
		todo_create: 								0,  # 创建任务
		todo_delete: 								1,	# 删除任务
		todo_complete: 							2, 	# 完成任务
		todo_assign_to_user: 				3, 	# 给任务指派完成者
		todo_update_assigned_user: 	4, 	# 修改任务完成者
		todo_update_deadline: 			5, 	# 修改任务完成时间
		todo_add_comment: 					6, 	# 评论任务

		# 应该还有
		todo_update: 								7 	# 修改任务

    }, scope: :with_action, i18n_scope: "event"

end

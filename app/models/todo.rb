class Todo < ActiveRecord::Base
	extend Enumerize

	belongs_to :creator, class_name: 'User'
	belongs_to :assign_user, class_name: 'User'
	belongs_to :assign_by_user, class_name: 'User'
	belongs_to :project
	has_many   :events, as: :eventable
	has_many   :comments

	# 没有被删除的任务
	scope :active, -> { where("status <> ?", 2) }

	enumerize :status, in: {
		in_progress:  0, 
		completed:    1,
		deleted:      2
		}, default: :in_progress, scope: :with_status, i18n_scope: "todo"

end

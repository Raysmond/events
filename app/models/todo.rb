class Todo < ActiveRecord::Base
	belongs_to :creator, class_name: 'User'
	belongs_to :assign_user, class_name: 'User'
	belongs_to :assign_by_user, class_name: 'User'
	belongs_to :project

end

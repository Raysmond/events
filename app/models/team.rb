class Team < ActiveRecord::Base
	has_many :projects
	has_and_belongs_to_many :users
	belongs_to :creator, class_name: "User"
end

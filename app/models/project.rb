class Project < ActiveRecord::Base
	belongs_to :user
	belongs_to :team
	has_many   :todos
	has_many   :events, as: :ownerable
	has_many   :users, :through => :accesses
	has_many   :accesses

	validates :team_id,         presence: true
	validates :user_id,         presence: true
end

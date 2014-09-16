class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_and_belongs_to_many :teams
  has_many :created_teams, class_name: 'Team', foreign_key: 'creator_id'
  has_many :created_todos, class_name: 'Todo', foreign_key: 'creator_id' 
  has_many :assigned_todos, class_name: 'Todo', foreign_key: 'assign_user_id' 

  validates :name,         presence: true
  
end

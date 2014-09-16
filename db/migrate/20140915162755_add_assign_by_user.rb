class AddAssignByUser < ActiveRecord::Migration
  def change
  	add_column :todos, :assign_by_user_id, :integer
  end
end

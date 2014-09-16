class AddCurrentTeamIdToUser < ActiveRecord::Migration
  def change
  	add_column :users, :current_team_id, :integer
  end
end

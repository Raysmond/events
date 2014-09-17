class AlterEventModel < ActiveRecord::Migration
  def change
  	remove_column :events, :title
  	remove_column :events, :content
  	remove_column :events, :owner
  	add_column :events, :ownerable_id, :integer
  	add_column :events, :ownerable_type, :string
  end
end

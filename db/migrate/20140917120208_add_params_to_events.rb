class AddParamsToEvents < ActiveRecord::Migration
  def change
  	add_column :events, :params, :text
  end
end

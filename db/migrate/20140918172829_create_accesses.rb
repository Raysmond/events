class CreateAccesses < ActiveRecord::Migration
  def change
    create_table :accesses do |t|
      t.integer :project_id
      t.integer :user_id
      t.integer :privilege

      t.timestamps
    end
  end
end

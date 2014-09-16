class CreateTodos < ActiveRecord::Migration
  def change
    create_table :todos do |t|
      t.string :title
      t.integer :creator_id
      t.integer :assign_user_id
      t.integer :project_id
      t.datetime :deadline

      t.timestamps
    end
  end
end

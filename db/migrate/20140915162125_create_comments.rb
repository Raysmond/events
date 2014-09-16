class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :parent_id
      t.integer :todo_id
      t.integer :user_id
      t.text :content
      t.boolean :deleted

      t.timestamps
    end
  end
end

class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :user_id
      t.integer :action
      t.integer :eventable_id
      t.string :eventable_type
      t.string :title
      t.text :content
      t.string :owner

      t.timestamps
    end
  end
end

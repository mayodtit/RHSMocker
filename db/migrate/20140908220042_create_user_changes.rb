class CreateUserChanges < ActiveRecord::Migration
  def change
    create_table :user_changes do |t|
      t.integer :user_id
      t.integer :actor_id
      t.text :data

      t.timestamps
    end
  end
end

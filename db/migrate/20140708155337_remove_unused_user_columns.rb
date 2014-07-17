class RemoveUnusedUserColumns < ActiveRecord::Migration
  def up
    remove_column :users, :test_user
    remove_column :users, :marked_for_deletion
  end

  def down
    add_column :users, :test_user, :boolean, default: false, null: false
    add_column :users, :marked_for_deletion, :boolean, default: false, null: false
  end
end

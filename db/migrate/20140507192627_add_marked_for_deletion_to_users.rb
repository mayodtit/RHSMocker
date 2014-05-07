class AddMarkedForDeletionToUsers < ActiveRecord::Migration
  def change
    add_column :users, :marked_for_deletion, :boolean
  end
end

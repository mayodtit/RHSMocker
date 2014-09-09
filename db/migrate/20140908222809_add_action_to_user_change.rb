class AddActionToUserChange < ActiveRecord::Migration
  def change
    add_column :user_changes, :action, :string
  end
end

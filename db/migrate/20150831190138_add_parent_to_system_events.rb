class AddParentToSystemEvents < ActiveRecord::Migration
  def change
    add_column :system_events, :parent_id, :integer
  end
end

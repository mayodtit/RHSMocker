class AddResourceToSystemEvent < ActiveRecord::Migration
  def change
    add_column :system_events, :resource_id, :integer
    add_column :system_events, :resource_type, :string
    add_column :system_events, :resource_attribute, :string
  end
end

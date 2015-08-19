class AddResourceToSystemEventTemplate < ActiveRecord::Migration
  def change
    add_column :system_event_templates, :resource_id, :integer
    add_column :system_event_templates, :resource_type, :string
  end
end

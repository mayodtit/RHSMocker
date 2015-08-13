class AddResourceAttributeToSystemEventTemplate < ActiveRecord::Migration
  def change
    add_column :system_event_templates, :resource_attribute, :string
  end
end

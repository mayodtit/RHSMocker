class RemoveSystemEventTemplateVersioning < ActiveRecord::Migration
  def up
    remove_column :system_event_templates, :unique_id
    remove_column :system_event_templates, :version
    remove_column :system_event_templates, :state
  end

  def down
    add_column :system_event_templates, :unique_id, :string, null: false
    add_column :system_event_templates, :version, :integer, null: false, default: 0
    add_column :system_event_templates, :state, :string
  end
end

class RemoveNameFromSystemEventTemplates < ActiveRecord::Migration
  def up
    remove_column :system_event_templates, :name
  end

  def down
    add_column :system_event_templates, :name, :string, null: false
  end
end

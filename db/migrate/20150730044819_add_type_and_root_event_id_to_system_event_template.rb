class AddTypeAndRootEventIdToSystemEventTemplate < ActiveRecord::Migration
  def change
    add_column :system_event_templates, :type, :string
    add_column :system_event_templates, :root_event_template_id, :integer
  end
end

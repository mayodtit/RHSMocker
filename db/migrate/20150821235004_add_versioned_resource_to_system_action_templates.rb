class AddVersionedResourceToSystemActionTemplates < ActiveRecord::Migration
  def change
    add_column :system_action_templates, :versioned_resource_unique_id, :string
    add_column :system_action_templates, :versioned_resource_type, :string
  end
end

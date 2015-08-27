class AddUnversionedResourceToSystemActionTemplates < ActiveRecord::Migration
  def change
    add_column :system_action_templates, :unversioned_resource_id, :integer
    add_column :system_action_templates, :unversioned_resource_type, :string
  end
end

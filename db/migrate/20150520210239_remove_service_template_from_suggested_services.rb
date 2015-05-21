class RemoveServiceTemplateFromSuggestedServices < ActiveRecord::Migration
  def up
    remove_column :suggested_services, :service_template_id
  end

  def down
    add_column :suggested_services, :service_template_id, :integer
  end
end

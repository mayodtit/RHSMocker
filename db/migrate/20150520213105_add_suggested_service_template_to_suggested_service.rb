class AddSuggestedServiceTemplateToSuggestedService < ActiveRecord::Migration
  def change
    add_column :suggested_services, :suggested_service_template_id, :integer
  end
end

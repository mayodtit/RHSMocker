class AddServiceRequestToServicesTemplates < ActiveRecord::Migration
  def change
    add_column :service_templates, :service_request, :text
  end
end

class AddServiceTemplateIdToService < ActiveRecord::Migration
  def change
    add_column :services, :service_template_id, :integer
  end
end

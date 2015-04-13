class AddServiceUpdateToServiceTemplate < ActiveRecord::Migration
  def change
    add_column :service_templates, :service_update, :text
  end
end

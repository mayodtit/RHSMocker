class AddVersionToServiceTemplates < ActiveRecord::Migration
  def change
    add_column :service_templates, :version, :integer, null: false, default: 0
  end
end

class ChangeServiceTemplateDescriptionToText < ActiveRecord::Migration
  def up
    change_column :service_templates, :description, :text
  end

  def down
    change_column :service_templates, :description, :string
  end
end

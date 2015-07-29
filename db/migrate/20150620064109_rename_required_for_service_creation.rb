class RenameRequiredForServiceCreation < ActiveRecord::Migration
  def up
    rename_column :data_field_templates, :required_for_service_creation, :required_for_service_start
  end

  def down
    rename_column :data_field_templates, :required_for_service_start, :required_for_service_creation
  end
end

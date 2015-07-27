class CreateDataFieldTemplates < ActiveRecord::Migration
  def change
    create_table :data_field_templates do |t|
      t.references :service_template
      t.string :name
      t.string :type
      t.boolean :required_for_service_creation
      t.timestamps
    end
  end
end

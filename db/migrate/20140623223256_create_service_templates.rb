class CreateServiceTemplates < ActiveRecord::Migration
  def change
    create_table :service_templates do |t|
      t.string :name, null: false
      t.string :title, null: false
      t.string :description
      t.integer :service_type_id, null: false
      t.integer :time_estimate

      t.timestamps
    end
  end
end

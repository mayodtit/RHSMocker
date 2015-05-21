class CreateSuggestedServiceTemplates < ActiveRecord::Migration
  def change
    create_table :suggested_service_templates do |t|
      t.references :service_template
      t.string :title
      t.text :description
      t.text :message
      t.timestamps
    end
  end
end

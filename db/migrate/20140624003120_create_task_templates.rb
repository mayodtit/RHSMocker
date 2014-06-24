class CreateTaskTemplates < ActiveRecord::Migration
  def change
    create_table :task_templates do |t|
      t.string :name, null: false
      t.string :title, null: false
      t.string :description
      t.integer :time_estimate
      t.integer :service_ordinal
      t.integer :service_template_id

      t.timestamps
    end
  end
end

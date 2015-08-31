class CreateTaskTemplateSets < ActiveRecord::Migration
  def change
    create_table :task_template_sets do |t|
      t.boolean :result

      t.timestamps
    end
  end
end

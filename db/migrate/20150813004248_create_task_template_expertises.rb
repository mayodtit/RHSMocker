class CreateTaskTemplateExpertises < ActiveRecord::Migration
  def change
    create_table :task_template_expertises do |t|
      t.references :task_template
      t.references :expertise
      t.timestamps
    end
    add_index "task_template_expertises", ["expertise_id"], :name => "index_task_template_expertises_on_expertise_id"
  end
end

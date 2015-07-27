class RemoveTaskRequirementTemplates < ActiveRecord::Migration
  def up
    drop_table :task_requirement_templates
  end

  def down
    create_table "task_requirement_templates", :force => true do |t|
      t.string   "title",            :null => false
      t.text     "description"
      t.integer  "task_template_id"
      t.datetime "created_at",       :null => false
      t.datetime "updated_at",       :null => false
    end

    add_index "task_requirement_templates", ["task_template_id"], :name => "index_task_requirement_templates_on_task_template_id"
  end
end

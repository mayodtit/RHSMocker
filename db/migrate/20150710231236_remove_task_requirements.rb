class RemoveTaskRequirements < ActiveRecord::Migration
  def up
    drop_table :task_requirements
  end

  def down
    create_table "task_requirements", :force => true do |t|
      t.string   "title",                                          :null => false
      t.text     "description"
      t.integer  "task_requirement_template_id"
      t.integer  "task_id"
      t.boolean  "completed",                    :default => true
      t.datetime "created_at",                                     :null => false
      t.datetime "updated_at",                                     :null => false
    end

    add_index "task_requirements", ["task_requirement_template_id"], :name => "index_task_requirements_on_task_requirement_template_id"
  end
end

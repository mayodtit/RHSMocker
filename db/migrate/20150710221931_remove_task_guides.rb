class RemoveTaskGuides < ActiveRecord::Migration
  def up
    drop_table :task_guides
  end

  def down
    create_table "task_guides", :force => true do |t|
      t.text     "description"
      t.integer  "task_template_id"
      t.datetime "created_at",       :null => false
      t.datetime "updated_at",       :null => false
      t.string   "title"
    end
    add_index "task_guides", ["task_template_id"], :name => "index_task_guides_on_task_template_id"
  end
end

class CreateTaskGuides < ActiveRecord::Migration
  def change
    create_table :task_guides do |t|
      t.string :description
      t.integer  :task_template_id
      t.datetime :created_at, :null => false
      t.datetime :updated_at, :null => false
    end
  end
end

class CreateTaskRequirements < ActiveRecord::Migration
  def change
    create_table :task_requirement_templates do |t|
      t.string :title, :null => false
      t.text :description
      t.integer  :task_template_id
      t.datetime :created_at, :null => false
      t.datetime :updated_at, :null => false
    end

    create_table :task_requirements do |t|
      t.string :title, :null => false
      t.text :description
      t.integer :task_requirement_template_id
      t.integer :task_id
      t.boolean :completed, :default => false
      t.datetime :created_at, :null => false
      t.datetime :updated_at, :null => false
    end
  end
end

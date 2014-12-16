class CreateGuides < ActiveRecord::Migration
  def change
    create_table :guides do |t|
      t.string :description
      t.integer  :task_template_id
      t.datetime :created_at, :null => false
      t.datetime :updated_at, :null => false
    end
  end
end

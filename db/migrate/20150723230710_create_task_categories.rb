class CreateTaskCategories < ActiveRecord::Migration
  def change
    create_table :task_categories do |t|
      t.string :title
      t.text :description
      t.integer :priority_weight
    end
  end
end

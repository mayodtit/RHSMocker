class CreateTaskCategoryExpertises < ActiveRecord::Migration
  def change
    create_table :task_category_expertises do |t|
      t.references :task_category
      t.references :expertise
      t.timestamps
    end
    add_index "task_category_expertises", ["expertise_id"], :name => "index_task_category_expertises_on_expertise_id"
  end
end

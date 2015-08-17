class AddExpertiseIdToTaskCategories < ActiveRecord::Migration
  def change
    add_column :task_categories, :expertise_id, :integer
  end
end

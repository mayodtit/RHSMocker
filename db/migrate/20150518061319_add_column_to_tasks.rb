class AddColumnToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :modal_template_id, :integer
  end
end

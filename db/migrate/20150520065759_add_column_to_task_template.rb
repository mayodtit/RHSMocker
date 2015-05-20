class AddColumnToTaskTemplate < ActiveRecord::Migration
  def change
    add_column :task_templates, :modal_template_id, :integer
  end
end

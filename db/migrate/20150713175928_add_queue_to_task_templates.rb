class AddQueueToTaskTemplates < ActiveRecord::Migration
  def change
    add_column :task_templates, :queue, :string
  end
end

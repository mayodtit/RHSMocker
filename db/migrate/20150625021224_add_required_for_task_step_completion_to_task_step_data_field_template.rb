class AddRequiredForTaskStepCompletionToTaskStepDataFieldTemplate < ActiveRecord::Migration
  def change
    add_column :task_step_data_field_templates, :required_for_task_step_completion, :boolean
  end
end

class TaskStepDataField < ActiveRecord::Base
  belongs_to :task_step, inverse_of: :task_step_data_fields
  belongs_to :task_data_field, inverse_of: :task_step_data_fields
  has_one :data_field, through: :task_data_field
  belongs_to :task_step_data_field_template, inverse_of: :task_step_data_fields

  attr_accessible :task_step, :task_step_id, :task_data_field, :task_data_field_id,
                  :task_step_data_field_template, :task_step_data_field_template_id

  validates :task_step, :task_data_field, :task_step_data_field_template, presence: true
  validate :task_data_field_is_output

  delegate :ordinal, :required_for_task_step_completion?, to: :task_step_data_field_template

  def self.required
    includes(:task_step_data_field_template).where(task_step_data_field_templates: {required_for_task_step_completion: true})
  end

  private

  def task_data_field_is_output
    unless task_data_field.try(:output?)
      errors.add(:task_data_field, 'must be output data field')
    end
  end
end

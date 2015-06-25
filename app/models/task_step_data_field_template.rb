class TaskStepDataFieldTemplate < ActiveRecord::Base
  belongs_to :task_step_template, inverse_of: :task_step_data_field_templates
  belongs_to :task_data_field_template, inverse_of: :task_step_data_field_templates
  has_many :task_step_data_fields, inverse_of: :task_step_data_field_template

  attr_accessible :task_step_template, :task_step_template_id,
                  :task_data_field_template, :task_data_field_template_id,
                  :ordinal, :required_for_task_step_completion

  validates :task_step_template, :task_data_field_template, presence: true
  validates :task_data_field_template_id, uniqueness: {scope: :task_step_template_id}
  validates :ordinal, presence: true,
                      uniqueness: {scope: :task_step_template_id},
                      numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :required_for_task_step_completion, inclusion: {in: [true, false]}
  validate :task_data_field_template_is_output

  before_validation :set_defaults, on: :create

  private

  def set_defaults
    self.ordinal = task_step_template.try(:task_step_data_field_templates).try(:max_by, &:ordinal).try(:ordinal).try(:+, 1) || 0
    self.required_for_task_step_completion = false if required_for_task_step_completion.nil?
    true
  end

  def task_data_field_template_is_output
    unless task_data_field_template.try(:output?)
      errors.add(:task_data_field_template, 'must be output data field')
    end
  end
end

class TaskStep < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :task, inverse_of: :task_steps
  belongs_to :task_step_template, inverse_of: :task_steps
  has_many :task_step_data_fields, inverse_of: :task_step,
                                   dependent: :destroy
  has_many :task_data_fields, through: :task_step_data_fields
  has_many :data_fields, through: :task_data_fields

  attr_accessible :task, :task_id, :task_step_template, :task_step_template_id

  validates :task, :task_step_template, presence: true
  validates :completed, inclusion: {in: [true, false]}

  before_validation :set_defaults, on: :create
  after_create :create_task_step_data_fields!, if: :task_step_template

  delegate :description, :ordinal, :details, to: :task_step_template

  def injected_details
    details.gsub(RegularExpressions.capture_braces) do |match|
      task_data_field_value(match[1..-2]) || match
    end
  end

  private

  def set_defaults
    self.completed = false if completed.nil?
    true
  end

  def create_task_step_data_fields!
    task_step_template.task_step_data_field_templates.each do |task_step_data_field_template|
      task_step_data_fields.create!(task_step_data_field_template: task_step_data_field_template,
                                    task_data_field: task.output_task_data_fields.find_by_task_data_field_template_id!(task_step_data_field_template.task_data_field_template_id))
    end
  end

  def task_data_field_value(key)
    task.data_fields.includes(:data_field_template).where(data_field_templates: {name: (key)}).first.try(:data)
  end
end

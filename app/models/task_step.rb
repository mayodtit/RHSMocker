class TaskStep < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :task, inverse_of: :task_steps
  belongs_to :task_step_template, inverse_of: :task_steps
  has_many :task_step_data_fields, inverse_of: :task_step
  has_many :task_data_fields, through: :task_step_data_fields
  has_many :data_fields, through: :task_data_fields

  attr_accessible :task, :task_id, :task_step_template, :task_step_template_id

  validates :task, :task_step_template, presence: true
  validates :completed, inclusion: {in: [true, false]}

  before_validation :set_defaults, on: :create
  after_create :create_task_step_data_fields!, if: :task_step_template

  delegate :description, :ordinal, to: :task_step_template

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
end

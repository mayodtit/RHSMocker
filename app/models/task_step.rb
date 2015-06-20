class TaskStep < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :task, inverse_of: :task_steps
  belongs_to :task_step_template, inverse_of: :task_steps

  attr_accessible :task, :task_id, :task_step_template, :task_step_template_id

  validates :task, :task_step_template, presence: true
  validates :completed, inclusion: {in: [true, false]}

  before_validation :set_defaults, on: :create

  delegate :description, :ordinal, to: :task_step_template

  private

  def set_defaults
    self.completed = false if completed.nil?
    true
  end
end

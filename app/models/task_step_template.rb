class TaskStepTemplate < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :task_template, inverse_of: :task_step_templates
  has_many :task_step_data_field_templates, inverse_of: :task_step_template,
                                            dependent: :destroy
  has_many :task_data_field_templates, through: :task_step_data_field_templates
  has_many :data_field_templates, through: :task_data_field_templates
  has_many :task_steps, inverse_of: :task_step_template

  attr_accessible :task_template, :task_template_id, :description, :ordinal,
                  :details, :template

  validates :task_template, :description, presence: true
  validates :ordinal, presence: true,
                      uniqueness: {scope: :task_template_id},
                      numericality: {only_integer: true, greater_than_or_equal_to: 0}

  before_validation :set_defaults, on: :create

  private

  def set_defaults
    self.ordinal = task_template.try(:task_step_templates).try(:max_by, &:ordinal).try(:ordinal).try(:+, 1) || 0
  end
end

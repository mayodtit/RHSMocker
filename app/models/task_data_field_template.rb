class TaskDataFieldTemplate < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  self.inheritance_column = nil
  TYPES = %i(input output)

  belongs_to :task_template, inverse_of: :task_data_field_templates
  belongs_to :data_field_template, inverse_of: :task_data_field_templates
  has_many :task_step_data_field_templates, inverse_of: :task_data_field_template,
                                            dependent: :destroy
  has_many :task_step_templates, through: :task_step_data_field_templates
  has_many :task_data_fields, inverse_of: :task_data_field_template
  has_many :tasks, through: :task_data_fields
  has_many :data_fields, through: :task_data_fields
  symbolize :type, in: TYPES

  attr_accessible :task_template, :task_template_id, :data_field_template,
                  :data_field_template_id, :section, :type

  validates :task_template, :data_field_template, presence: true
  validates :data_field_template_id, uniqueness: {scope: %i(task_template_id type)}
  validates :type, presence: true, inclusion: {in: TYPES}
  validate :associations_have_same_service_template

  def input?
    type == :input
  end

  def output?
    type == :output
  end

  private

  def associations_have_same_service_template
    unless task_template.try(:service_template) == data_field_template.try(:service_template)
      errors.add(:base, 'associations must have same service template')
    end
  end
end

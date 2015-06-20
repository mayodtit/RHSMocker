class TaskDataFieldTemplate < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  self.inheritance_column = nil
  TYPES = %i(input output)

  belongs_to :task_template, inverse_of: :task_data_field_templates
  belongs_to :data_field_template, inverse_of: :task_data_field_templates
  has_many :task_data_fields, inverse_of: :task_data_field_template
  has_many :tasks, through: :task_data_fields
  has_many :data_fields, through: :task_data_fields

  attr_accessible :task_template, :task_template_id, :data_field_template,
                  :data_field_template_id, :ordinal, :section, :type

  validates :task_template, :data_field_template, presence: true
  validates :ordinal, presence: true,
                      uniqueness: {scope: :task_template_id},
                      numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :type, presence: true, inclusion: {in: TYPES}

  before_validation :set_defaults, on: :create

  private

  def set_defaults
    self.ordinal = task_template.try(:task_data_field_templates).try(:max_by, &:ordinal).try(:+, 1) || 0
  end
end

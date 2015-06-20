class TaskDataFieldTemplate < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :task_template, inverse_of: :task_data_field_templates
  belongs_to :data_field_template, inverse_of: :task_data_field_templates

  attr_accessible :task_template, :task_template_id, :data_field_template, :data_field_template_id, :ordinal, :section

  validates :task_template, :data_field_template, presence: true
  validates :ordinal, presence: true,
                      uniqueness: {scope: :task_template_id},
                      numericality: {only_integer: true, greater_than_or_equal_to: 0}

  before_validation :set_defaults, on: :create

  private

  def set_defaults
    self.ordinal = task_template.try(:task_data_field_templates).try(:max_by, &:ordinal).try(:+, 1) || 0
  end
end

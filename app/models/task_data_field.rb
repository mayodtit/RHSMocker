class TaskDataField < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  self.inheritance_column = nil
  TYPES = %i(input output)

  belongs_to :task, inverse_of: :task_data_fields
  belongs_to :data_field, inverse_of: :task_data_fields
  belongs_to :task_data_field_template, inverse_of: :task_data_fields

  attr_accessible :task, :task_id, :data_field, :data_field_id, :task_data_field_template,
                  :task_data_field_template_id, :type

  validates :task, :data_field, :task_data_field_template, presence: true
  validates :type, presence: true, inclusion: {in: TYPES}

  delegate :ordinal, :section, to: :task_data_field_template
end

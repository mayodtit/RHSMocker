class TaskDataField < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :task, inverse_of: :task_data_fields
  belongs_to :data_field, inverse_of: :task_data_fields
  belongs_to :task_data_field_template, inverse_of: :task_data_fields

  attr_accessible :task, :task_id, :data_field, :data_field_id, :task_data_field_template,
                  :task_data_field_template_id

  validates :task, :data_field, :task_data_field_template, presence: true

  delegate :ordinal, :section, to: :task_data_field_template
end

class TaskDataField < ActiveRecord::Base
  self.inheritance_column = nil
  TYPES = %i(input output)

  belongs_to :task, inverse_of: :task_data_fields
  belongs_to :data_field, inverse_of: :task_data_fields
  belongs_to :task_data_field_template, inverse_of: :task_data_fields
  symbolize :type, in: TYPES

  attr_accessible :task, :task_id, :data_field, :data_field_id, :task_data_field_template,
                  :task_data_field_template_id, :type

  validates :task, :data_field, :task_data_field_template, presence: true
  validates :type, presence: true, inclusion: {in: TYPES}

  before_validation :set_defaults, on: :create

  delegate :ordinal, :section, to: :task_data_field_template

  private

  def set_defaults
    self.type ||= task_data_field_template.try(:type)
    true
  end
end

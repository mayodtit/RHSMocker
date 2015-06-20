class DataFieldTemplate < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  self.inheritance_column = nil

  belongs_to :service_template, inverse_of: :data_field_templates
  has_many :task_data_field_templates, inverse_of: :data_field_template
  has_many :task_templates, through: :task_data_field_templates
  has_many :data_fields, inverse_of: :data_field_template

  attr_accessible :service_template, :service_template_id, :name, :type,
                  :required_for_service_start

  validates :service_template, :name, :type, presence: true
  validates :required_for_service_start, inclusion: {in: [true, false]}

  before_validation :set_defaults, on: :create

  private

  def set_defaults
    self.required_for_service_start = false if required_for_service_start.nil?
    true
  end
end

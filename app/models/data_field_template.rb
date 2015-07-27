class DataFieldTemplate < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  self.inheritance_column = nil
  TYPES = %i(text textarea date datetime boolean tel)

  belongs_to :service_template, inverse_of: :data_field_templates
  has_many :task_data_field_templates, inverse_of: :data_field_template
  has_many :task_templates, through: :task_data_field_templates
  has_many :data_fields, inverse_of: :data_field_template
  symbolize :type, in: TYPES

  attr_accessible :service_template, :service_template_id, :name, :type,
                  :required_for_service_start

  validates :service_template, presence: true
  validates :name, presence: true, uniqueness: {scope: :service_template_id}
  validates :type, presence: true, inclusion: {in: TYPES}
  validates :required_for_service_start, inclusion: {in: [true, false]}

  before_validation :set_defaults, on: :create

  def create_deep_copy!(new_service_template)
    transaction do
      new_service_template.data_field_templates.create!(attributes.slice(*%w(name type required_for_service_start)))
    end
  end

  private

  def set_defaults
    self.required_for_service_start = false if required_for_service_start.nil?
    true
  end
end

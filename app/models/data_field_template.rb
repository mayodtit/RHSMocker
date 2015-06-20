class DataFieldTemplate < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  self.inheritance_column = nil

  belongs_to :service_template, inverse_of: :data_field_templates

  attr_accessible :service_template, :service_template_id, :name, :type,
                  :required_for_service_creation

  validates :service_template, :name, :type, presence: true
  validates :required_for_service_creation, inclusion: {in: [true, false]}

  before_validation :set_defaults, on: :create

  private

  def set_defaults
    self.required_for_service_creation = false if required_for_service_creation.nil?
    true
  end
end

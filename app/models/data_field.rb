class DataField < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :service, inverse_of: :data_fields
  belongs_to :data_field_template, inverse_of: :data_fields

  attr_accessible :service, :service_id, :data_field_template, :data_field_template_id, :data

  validates :service, :data_field_template, presence: true

  delegate :name, :type, :required_for_service_creation, to: :data_field_template

  def completed?
    data.present?
  end
end

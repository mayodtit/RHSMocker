class SystemEventTemplate < ActiveRecord::Base
  has_one :system_action_template, inverse_of: :system_event_template
  belongs_to :resource, polymorphic: true
  has_many :system_relative_event_templates, foreign_key: :root_event_template_id,
                                             inverse_of: :root_event_template,
                                             dependent: :destroy
  has_many :system_events, inverse_of: :system_event_template

  attr_accessible :title, :description,
                  :resource, :resource_id, :resource_type, :resource_attribute,
                  :system_action_template_attributes

  validates :title, presence: true

  accepts_nested_attributes_for :system_action_template

  def create_deep_copy!(new_appointment_template)
    transaction do
      new_system_event_template = self.class.create!(attributes.except('id', 'created_at', 'updated_at', 'root_event_template_id', 'resource_id', 'resource_type', 'resource_attribute', 'type', 'resource', 'system_action_template_attributes'))
      new_system_event_template.update_attributes!(resource: new_appointment_template)
      new_system_event_template
    end
  end
end

class AppointmentTemplateSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :name, :title, :description, :scheduled_at, :version, :unique_id, :state, :state_events, :created_at

  has_many :system_event_templates
end

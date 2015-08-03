class AppointmentTemplateSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :name, :title, :description, :scheduled_at

  has_many :system_event_templates
end

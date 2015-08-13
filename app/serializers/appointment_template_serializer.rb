class AppointmentTemplateSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :name, :title, :description, :version, :unique_id, :state, :state_events, :special_instructions, :reason_for_visit
end

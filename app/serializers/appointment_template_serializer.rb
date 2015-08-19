class AppointmentTemplateSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :name, :title, :description, :version, :unique_id, :state, :state_events, :special_instructions, :reason_for_visit, :scheduled_at_system_event_template_id, :discharged_at_system_event_template_id

  delegate :scheduled_at_system_event_template, :discharged_at_system_event_template, to: :object

  def scheduled_at_system_event_template_id
    scheduled_at_system_event_template.try(:id)
  end

  def discharged_at_system_event_template_id
    discharged_at_system_event_template.try(:id)
  end
end

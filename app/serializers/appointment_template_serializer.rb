class AppointmentTemplateSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :title, :description, :version, :unique_id, :state, :state_events, :special_instructions,
             :reason_for_visit, :scheduled_at_system_event_template_id, :discharged_at_system_event_template_id,
             :unpublished_version_id

  delegate :scheduled_at_system_event_template, :discharged_at_system_event_template, :unique_id, :published?, to: :object

  def scheduled_at_system_event_template_id
    scheduled_at_system_event_template.try(:id)
  end

  def discharged_at_system_event_template_id
    discharged_at_system_event_template.try(:id)
  end

  private

  def unpublished_version_id
    return nil unless unique_id && published?
    if unpublished_template = AppointmentTemplate.unpublished.find_by_unique_id(unique_id)
      unpublished_template.id
    else
      nil
    end
  end
end

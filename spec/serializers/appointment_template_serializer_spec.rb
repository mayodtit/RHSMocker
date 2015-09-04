require 'spec_helper'

describe AppointmentTemplateSerializer do
  let!(:appointment_template) { create(:appointment_template, :with_scheduled_at_system_event_template, :with_discharged_at_system_event_template, :published) }
  let!(:unpublished_version_template) {create(:appointment_template, unique_id: appointment_template.unique_id)}

  it 'renders the appointment template' do
    result = appointment_template.serializer.as_json
    expect(result).to eq(
      {
        id: appointment_template.id,
        title: appointment_template.title,
        description: appointment_template.description,
        version: appointment_template.version,
        unique_id: appointment_template.unique_id,
        state: appointment_template.state,
        state_events: appointment_template.state_events,
        special_instructions: appointment_template.special_instructions,
        reason_for_visit: appointment_template.reason_for_visit,
        scheduled_at_system_event_template_id: appointment_template.scheduled_at_system_event_template.id,
        discharged_at_system_event_template_id: appointment_template.discharged_at_system_event_template.id,
        unpublished_version_id: unpublished_version_template.id
      }
    )
  end
end

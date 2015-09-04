require 'spec_helper'

describe SystemEventTemplate do
  it_has_a 'valid factory'
  it_has_a 'valid factory', :with_system_action_template
  it_validates 'presence of', :title

  describe '#create_deep_copy!' do
    let!(:origin_appointment_template) { create(:appointment_template, :with_scheduled_at_system_event_template, :published) }
    let!(:origin_system_event_template) { origin_appointment_template.scheduled_at_system_event_template }
    let!(:new_appointment_template) { create(:appointment_template, :with_scheduled_at_system_event_template, :unpublished) }

    it 'creates a deep copy including nested templates' do
      new_system_event_template = origin_system_event_template.create_deep_copy!(new_appointment_template)
      expect(new_system_event_template).to be_valid
      expect(new_system_event_template).to be_persisted
      expect(new_system_event_template.resource).to eq(new_appointment_template)
    end
  end
end

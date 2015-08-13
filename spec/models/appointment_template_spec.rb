require 'spec_helper'

describe AppointmentTemplate do
  it_has_a 'valid factory'
  it_has_a 'valid factory', :unpublished
  it_has_a 'valid factory', :published
  it_has_a 'valid factory', :retired

  describe 'traits' do
    describe '#with_scheduled_at_system_event_template' do
      let(:appointment_template) { create(:appointment_template, :with_scheduled_at_system_event_template) }

      it_has_a 'valid factory', :with_scheduled_at_system_event_template

      it 'also creates scheduled_at_system_event_template' do
        expect(appointment_template).to be_valid
        expect(appointment_template).to be_persisted
        system_event_template = appointment_template.reload.scheduled_at_system_event_template
        expect(system_event_template).to be_present
        expect(system_event_template).to be_valid
        expect(system_event_template).to be_persisted
        expect(system_event_template.resource_attribute).to eq('scheduled_at')
      end
    end

    describe '#with_scheduled_at_system_event_template' do
      let(:appointment_template) { create(:appointment_template, :with_discharged_at_system_event_template) }

      it_has_a 'valid factory', :with_discharged_at_system_event_template

      it 'also creates discharged_at_system_event_template' do
        expect(appointment_template).to be_valid
        expect(appointment_template).to be_persisted
        system_event_template = appointment_template.reload.discharged_at_system_event_template
        expect(system_event_template).to be_present
        expect(system_event_template).to be_valid
        expect(system_event_template).to be_persisted
        expect(system_event_template.resource_attribute).to eq('discharged_at')
      end
    end
  end

  it_validates 'presence of', :name
  it_validates 'presence of', :title
  it_validates 'presence of', :version
  it_validates 'presence of', :state
  it_validates 'uniqueness of', :state, :unique_id
  it_validates 'uniqueness of', :version, :unique_id

  describe '#create_deep_copy!' do
    let!(:origin_appointment_template) { create(:appointment_template, :published) }

    it 'creates a deep copy including nested templates' do
      new_appointment_template = origin_appointment_template.create_deep_copy!
      expect(new_appointment_template).to be_valid
      expect(new_appointment_template).to be_persisted
    end
  end
end

require 'spec_helper'

describe AppointmentTemplate do
  it_has_a 'valid factory'

  describe 'validations' do
    it_validates 'presence of', :name
    it_validates 'presence of', :title
    it_validates 'presence of', :version
    it_validates 'presence of', :state
    it_validates 'uniqueness of', :state, :unique_id
    it_validates 'uniqueness of', :version, :unique_id
  end

  describe '#create_deep_copy!' do
    let!(:origin_appointment_template) { create(:appointment_template, :published) }

    it 'creates a deep copy including nested templates' do
      new_appointment_template = origin_appointment_template.create_deep_copy!
      expect(new_appointment_template).to be_valid
      expect(new_appointment_template).to be_persisted
    end
  end
end

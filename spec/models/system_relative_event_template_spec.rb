require 'spec_helper'

describe SystemRelativeEventTemplate do
  it_has_a 'valid factory'
  it_validates 'presence of', :root_event_template

  describe '#create_deep_copy!' do
    let!(:origin_system_event_template) { create(:system_event_template) }
    let!(:origin_system_relative_event_template) { create(:system_relative_event_template, root_event_template: origin_system_event_template) }
    let!(:new_system_event_template) { create(:system_event_template) }

    it 'creates a deep copy including nested templates' do
      new_system_relative_event_template = origin_system_relative_event_template.create_deep_copy!(new_system_event_template)
      expect(new_system_relative_event_template).to be_valid
      expect(new_system_relative_event_template).to be_persisted
      expect(new_system_relative_event_template.root_event_template).to eq(new_system_event_template)
    end
  end
end

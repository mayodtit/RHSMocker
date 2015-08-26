require 'spec_helper'

describe SystemEventTemplateSerializer do
  let(:system_event_template) { create(:system_event_template, :with_system_action_template) }
  let(:sample_time) { Time.parse('2015-08-12 00:00:00 -0700') }

  before do
    Timecop.freeze
  end

  after do
    Timecop.return
  end

  it 'renders the system event template' do
    result = system_event_template.serializer.as_json
    expect(result).to eq(
      {
        id: system_event_template.id,
        title: system_event_template.title,
        description: system_event_template.description,
        sample_ordinal: sample_time.to_i,
        system_action_template: system_event_template.system_action_template.serializer.as_json
      }
    )
  end

  describe 'sample_time' do
    context 'with a SystemEventTemplate' do
      it 'sets the sample_ordinal as an integer based on the time' do
        result = system_event_template.serializer.as_json
        expect(result[:sample_ordinal]).to eq(sample_time.to_i)
      end
    end

    context 'with a SystemRelativeEventTemplate' do
      let(:time_offset) { create(:time_offset, offset_type: :fixed, direction: :before, absolute_minutes: 60) }
      let(:system_relative_event_template) { create(:system_relative_event_template, time_offset: time_offset) }

      it 'calculates the sample_ordinal based on the sample_time' do
        result = system_relative_event_template.serializer.as_json
        expect(result[:sample_ordinal]).to eq((sample_time - 1.hour).to_i)
      end
    end
  end
end

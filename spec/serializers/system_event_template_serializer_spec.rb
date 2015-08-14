require 'spec_helper'

describe SystemEventTemplateSerializer do
  let(:system_event_template) { create(:system_event_template) }

  it 'renders the system event template' do
    result = system_event_template.serializer.as_json
    expect(result).to eq(
      {
        id: system_event_template.id,
        name: system_event_template.name,
        title: system_event_template.title,
        description: system_event_template.description,
        state: system_event_template.state,
        unique_id: system_event_template.unique_id,
        version: system_event_template.version
      }
    )
  end

  describe 'sample_time option' do
    before do
      Timecop.freeze
    end

    after do
      Timecop.return
    end

    context 'with a SystemEventTemplate' do
      it 'sets the sample_ordinal as an integer based on the time' do
        result = system_event_template.serializer(sample_time: Time.now).as_json
        expect(result[:sample_ordinal]).to eq(Time.now.to_i)
      end
    end

    context 'with a SystemRelativeEventTemplate' do
      let(:time_offset) { create(:time_offset, offset_type: :fixed, direction: :before, fixed_time: Time.at(1.hour)) }
      let(:system_relative_event_template) { create(:system_relative_event_template, time_offset: time_offset) }

      it 'calculates the sample_ordinal based on the sample_time' do
        result = system_relative_event_template.serializer(sample_time: Time.now).as_json
        expect(result[:sample_ordinal]).to eq((Time.now - 1.hour).to_i)
      end
    end
  end
end

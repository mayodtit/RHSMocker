require 'spec_helper'

describe CreateSystemEventsFromTemplatesService do
  before do
    Timecop.freeze(Time.parse('2015-09-02 12:00:00 -0700'))
  end

  after do
    Timecop.return
  end

  describe '#call' do
    let!(:user) { create(:member, :premium) }

    describe 'simple case' do
      let!(:system_event_template) { create(:system_event_template) }
      let(:params) do
        {
          user: user,
          root_system_event_template: system_event_template,
          trigger_at: Time.now
        }
      end

      it 'creates a system event' do
        event = described_class.new(params).call
        expect(event).to be_a SystemEvent
        expect(event).to be_valid
        expect(event).to be_persisted
        expect(event.system_event_template).to eq(system_event_template)
      end
    end

    describe 'complex case' do
      let!(:root_system_event_template) { create(:system_event_template) }
      let!(:relative_system_event_template_1) { create(:system_relative_event_template, root_event_template: root_system_event_template) }
      let!(:relative_system_event_template_2) { create(:system_relative_event_template, root_event_template: root_system_event_template) }
      let!(:nested_relative_system_event_template_3) { create(:system_relative_event_template, root_event_template: relative_system_event_template_1) }
      let(:params) do
        {
          user: user,
          root_system_event_template: root_system_event_template,
          trigger_at: Time.now
        }
      end

      it 'creates a tree of system events' do
        expect(SystemEvent.count).to eq(0)
        event = described_class.new(params).call
        expect(SystemEvent.count).to eq(4)
        expect(event).to be_a SystemEvent
        expect(event).to be_valid
        expect(event).to be_persisted
        expect(event.system_event_template).to eq(root_system_event_template)
      end
    end
  end
end

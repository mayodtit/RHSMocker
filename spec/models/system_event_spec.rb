require 'spec_helper'

describe SystemEvent do
  it_has_a 'valid factory'
  it_has_a 'valid factory', :scheduled
  it_has_a 'valid factory', :triggered
  it_has_a 'valid factory', :canceled
  it_validates 'presence of', :user
  it_validates 'presence of', :system_event_template
  it_validates 'presence of', :trigger_at

  describe 'state machine' do
    describe 'initial state' do
      it 'defaults to scheduled' do
        expect(described_class.new).to be_scheduled
      end
    end

    describe '#trigger' do
      let!(:system_action_template) { create(:system_action_template) }
      let!(:system_event_template) { system_action_template.system_event_template }
      let!(:system_event) { create(:system_event, system_event_template: system_event_template) }

      it 'calls the trigger service on event' do
        TriggerSystemEventService.should_receive(:new).once.and_call_original
        expect{ system_event.trigger! }.to change(SystemAction, :count).by(1)
        expect(system_event.reload).to be_triggered
      end
    end
  end
end

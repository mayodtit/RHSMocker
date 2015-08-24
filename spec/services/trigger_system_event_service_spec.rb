require 'spec_helper'

describe TriggerSystemEventService do
  describe '#call' do
    let!(:pha) { create(:pha) }
    let!(:user) { create(:member, :premium, pha: pha) }

    context 'for a system_message SystemEvent' do
      let!(:system_action_template) { create(:system_action_template, :system_message) }
      let!(:system_event_template) { system_action_template.system_event_template }
      let!(:system_event) { create(:system_event, user: user, system_event_template: system_event_template) }

      it 'creates a system message for the user' do
        expect{ described_class.new(system_event: system_event).call }.to change(Message, :count).by(1)
        message = Message.last
        expect(message.user).to eq(Member.robot)
        expect(message.system).to be_true
        expect(message.automated).to be_true
      end

      it 'creates a system action' do
        expect{ described_class.new(system_event: system_event).call }.to change(SystemAction, :count).by(1)
        action = SystemAction.last
        expect(action.system_event).to eq(system_event)
        expect(action.system_action_template).to eq(system_action_template)
        expect(action.result).to eq(Message.last)
      end
    end

    context 'for a pha_message SystemEvent' do
      let!(:system_action_template) { create(:system_action_template, :pha_message) }
      let!(:system_event_template) { system_action_template.system_event_template }
      let!(:system_event) { create(:system_event, user: user, system_event_template: system_event_template) }

      it 'creates a pha message for the user' do
        expect{ described_class.new(system_event: system_event).call }.to change(Message, :count).by(1)
        message = Message.last
        expect(message.user).to eq(pha)
        expect(message.system).to be_false
        expect(message.automated).to be_true
      end

      it 'creates a system action' do
        expect{ described_class.new(system_event: system_event).call }.to change(SystemAction, :count).by(1)
        action = SystemAction.last
        expect(action.system_event).to eq(system_event)
        expect(action.system_action_template).to eq(system_action_template)
        expect(action.result).to eq(Message.last)
      end
    end

    context 'for a service SystemEvent' do
      let!(:system_action_template) { create(:system_action_template, :service) }
      let!(:system_event_template) { system_action_template.system_event_template }
      let!(:system_event) { create(:system_event, user: user, system_event_template: system_event_template) }

      it 'creates a service for the user' do
        expect{ described_class.new(system_event: system_event).call }.to change(Service, :count).by(1)
        service = user.reload.services.last
        expect(service.service_template).to eq(system_action_template.published_versioned_resource)
        expect(service.creator).to eq(Member.robot)
      end

      it 'creates a system action' do
        expect{ described_class.new(system_event: system_event).call }.to change(SystemAction, :count).by(1)
        action = SystemAction.last
        expect(action.system_event).to eq(system_event)
        expect(action.system_action_template).to eq(system_action_template)
        expect(action.result).to eq(Service.last)
      end
    end
  end
end

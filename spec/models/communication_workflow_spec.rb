require 'spec_helper'

describe CommunicationWorkflow do
  it_has_a 'valid factory'
  it_validates 'presence of', :name
  it_validates 'uniqueness of', :name

  describe '#add_to_member' do
    let!(:pha) { create(:pha) }
    let!(:member) { create(:member, :premium, pha: pha) }
    let!(:communication_workflow) { create(:communication_workflow) }
    let!(:message_workflow_template) { create(:message_workflow_template, communication_workflow: communication_workflow) }

    it 'creates a scheduled message from the workflow' do
      expect{ communication_workflow.add_to_member(member) }.to change(ScheduledMessage, :count).by(1)
      s = ScheduledMessage.last
      expect(s.sender).to eq(pha)
      expect(s.consult).to eq(member.master_consult)
      expect(s.text).to eq(message_workflow_template.message_template.text)
    end

    context 'on a weekday' do
      before do
        Timecop.freeze(Time.new(2014, 7, 17, 0, 0, 0, '-07:00'))
      end

      after do
        Timecop.return
      end

      it 'creates a scheduled message the next business day at 9AM pacific' do
        expect{ communication_workflow.add_to_member(member) }.to change(ScheduledMessage, :count).by(1)
        s = ScheduledMessage.last
        expect(s.publish_at).to eq(Time.new(2014, 7, 18, 9, 0, 0, '-07:00'))
      end
    end

    context 'on a Friday' do
      before do
        Timecop.freeze(Time.new(2014, 7, 18, 0, 0, 0, '-07:00'))
      end

      after do
        Timecop.return
      end

      it 'creates a scheduled message on Monday at 9AM pacific' do
        expect{ communication_workflow.add_to_member(member) }.to change(ScheduledMessage, :count).by(1)
        s = ScheduledMessage.last
        expect(s.publish_at).to eq(Time.new(2014, 7, 21, 9, 0, 0, '-07:00'))
      end
    end

    context 'on a Sunday' do
      before do
        Timecop.freeze(Time.new(2014, 7, 20, 0, 0, 0, '-07:00'))
      end

      after do
        Timecop.return
      end

      it 'creates a scheduled message on Monday at 9AM pacific' do
        expect{ communication_workflow.add_to_member(member) }.to change(ScheduledMessage, :count).by(1)
        s = ScheduledMessage.last
        expect(s.publish_at).to eq(Time.new(2014, 7, 21, 9, 0, 0, '-07:00'))
      end
    end
  end
end

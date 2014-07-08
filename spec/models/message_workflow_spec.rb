require 'spec_helper'

describe MessageWorkflow do
  before do
    Timecop.freeze(Date.today.to_time)
  end

  after do
    Timecop.return
  end

  it_has_a 'valid factory'
  it_validates 'presence of', :name
  it_validates 'uniqueness of', :name

  describe '#add_to_member' do
    let!(:pha) { create(:pha) }
    let!(:member) { create(:member, :premium, pha: pha) }
    let!(:message_workflow) { create(:message_workflow) }
    let!(:message_workflow_template) { create(:message_workflow_template, message_workflow: message_workflow) }

    it 'creates a scheduled message from the workflow' do
      expect{ message_workflow.add_to_member(member) }.to change(ScheduledMessage, :count).by(1)
      s = ScheduledMessage.last
      expect(s.sender).to eq(pha)
      expect(s.consult).to eq(member.master_consult)
      expect(s.text).to eq(message_workflow_template.message_template.text)
      expect(s.publish_at.pacific.to_date).to eq(Time.now.pacific.to_date + message_workflow_template.days_delayed)
    end
  end
end

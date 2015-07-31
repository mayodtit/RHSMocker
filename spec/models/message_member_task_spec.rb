require 'spec_helper'

describe MessageMemberTask do
  let!(:service_type) { create(:service_type, name: 're-engagement', bucket: 'engagement') }

  it_has_a 'valid factory'
  it_validates 'foreign key of', :member
  it_validates 'foreign key of', :service_type

  describe '#set_defaults' do
    let(:task) { build(:message_member_task) }

    it 'creates a valid object and sets defaults' do
      expect(task).to be_valid
      expect(task.title).to eq("Message member")
      expect(task.description).to eq("Member has not been messages in a week. Please send them a message.")
      expect(task.service_type).to eq(service_type)
      expect(task.owner).to eq(task.member.pha)
    end

    it 'sets priority to 0' do
      task.valid?
      expect(task.priority).to eq(0)
    end
  end

  describe '#create_task_for_member' do
    let(:member) { build :member}
    it 'should create a new task' do
      MessageMemberTask.should_receive(:create!).with(member: member)
      MessageMemberTask.create_task_for_member(member)
    end
  end
end

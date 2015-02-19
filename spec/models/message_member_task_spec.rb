require 'spec_helper'

describe MessageMemberTask do
  before do
    @service_type = ServiceType.find_or_create_by_name! name: 're-engagement', bucket: 'engagement'
  end

  it_has_a 'valid factory'

  describe 'validations' do
    it_validates 'foreign key of', :member
    it_validates 'foreign key of', :service_type
  end

  describe '#set_required_attrs' do
    let(:task) { build :message_member_task }

    it 'sets title' do
      task.set_required_attrs
      task.title.should == "Message member"
    end

    it 'sets due_at to end of workday' do
      task.set_required_attrs
      task.due_at = Time.now.eighteen_oclock
    end

    it 'sets service type' do
      task.set_required_attrs
      task.service_type.should == @service_type
    end

    it 'sets the creator to the robot' do
      task.set_required_attrs
      task.creator.should == Member.robot
    end

    it 'sets the assignor  to the robot' do
      task.set_required_attrs
      task.assignor.should == Member.robot
    end

    it 'sets the owner to the members pha' do
      task.set_required_attrs
      task.owner.should == task.member.pha
    end

    it 'sets the description' do
      task.set_required_attrs
      task.description.should == "Member has not been messaging in two weeks. Please send them a message."
    end

    it 'sets the priority' do
      task.set_required_attrs
      task.priority.should == 0
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

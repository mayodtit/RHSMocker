require 'spec_helper'

describe AddTasksTask do
  before do
    @service_type = ServiceType.find_or_create_by_name! name: 're-engagement', bucket: 'engagement'
  end

  it_has_a 'valid factory'

  describe 'validations' do
    it_validates 'foreign key of', :member
    it_validates 'foreign key of', :service_type
  end

  describe '#set_required_attrs' do
    let(:task) { build :add_tasks_task }

    it 'sets title' do
      task.set_required_attrs
      task.title.should == "Find new services for member"
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

    it 'sets the owner to the members pha' do
      task.set_required_attrs
      task.owner.should == task.member.pha
    end

    it 'sets the assignor to the robot' do
      task.set_required_attrs
      task.assignor.should == Member.robot
    end

    it 'sets description' do
      task.set_required_attrs
      task.description.should == "The member current has no tasks in progress."
    end
  end

  describe '#create_if_member_has_no_tasks' do
    let!(:member) { create :member }

    context 'member has tasks' do
      let!(:add_tasks_task) { create :add_tasks_task, member: member }

      it 'does not create an offboard task' do
        AddTasksTask.should_not_receive(:create!)
        AddTasksTask.create_if_member_has_no_tasks(member)
      end
    end

    context 'member has no tasks' do

      it 'creates an offboard task' do
        AddTasksTask.should_receive(:create!)
        AddTasksTask.create_if_member_has_no_tasks(member)
      end
    end
  end
end

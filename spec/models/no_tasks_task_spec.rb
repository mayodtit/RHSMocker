require 'spec_helper'

describe NoTasksTask do
  before do
    @service_type = ServiceType.find_or_create_by_name! name: 're-engagement', bucket: 'engagement'
  end

  it_has_a 'valid factory'

  describe 'validations' do
    it_validates 'foreign key of', :member
    it_validates 'foreign key of', :subject
    it_validates 'foreign key of', :service_type
  end

  describe '#set_required_attrs' do
    let(:task) { build :no_tasks_task }

    it 'sets title' do
      task.set_required_attrs
      task.title.should == "Find new services for member"
    end

    it 'sets due_at to end of workday' do
      task.set_required_attrs
      task.due_at = Time.end_of_workday(Time.now)
    end

    it 'sets service type' do
      task.set_required_attrs
      task.service_type.should == @service_type
    end

    it 'sets the creator to the robot' do
      task.set_required_attrs
      task.creator.should == Member.robot
    end

    it 'sets the subject to the member' do
      task.set_required_attrs
      task.subject.should == task.member
    end

    it 'sets description' do
      task.set_required_attrs
      task.description.should == "The member currently has no current tasks assigned."
    end
  end

  describe '#create_if_member_has_no_tasks' do
    let!(:member) { create :member }

    context 'member has tasks' do
      let!(:no_tasks_task) { create :no_tasks_task, member: member }

      it 'does not create an offboard task' do
        NoTasksTask.should_not_receive(:create!)
        NoTasksTask.create_if_member_has_no_tasks(member)
      end
    end

    context 'member has no tasks' do

      it 'creates an offboard task' do
        NoTasksTask.should_receive(:create!)
        NoTasksTask.create_if_member_has_no_tasks(member)
      end
    end
  end
end

require 'spec_helper'

describe AddTasksTask do
  let!(:service_type) { create(:service_type, name: 're-engagement', bucket: 'engagement') }

  it_has_a 'valid factory'
  it_validates 'foreign key of', :member
  it_validates 'foreign key of', :service_type

  describe '#create_if_member_has_no_tasks' do
    let!(:member) { create :member }

    context 'member has tasks' do
      let!(:add_tasks_task) { create :add_tasks_task, member: member }

      it 'does not create an AddTasksTask task' do
        AddTasksTask.should_not_receive(:create!)
        AddTasksTask.create_if_member_has_no_tasks(member)
      end
    end

    context 'member has no tasks' do
      context 'member has not messaged' do
        it 'does not create an AddTasksTask task' do
          AddTasksTask.should_not_receive(:create!)
          AddTasksTask.create_if_member_has_no_tasks(member)
        end
      end

      context 'member has messaged' do
        let!(:message) { create :message, user_id: member.id}

        it 'creates an AddTasksTask' do
          AddTasksTask.should_receive(:create!)
          AddTasksTask.create_if_member_has_no_tasks(member)
        end
      end
    end
  end
end

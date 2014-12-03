require 'spec_helper'

describe ViewTaskTask do

  it_has_a 'valid factory'

  describe 'validations' do
    it_validates 'presence of', :assigned_task
  end

  describe '#create_task_for_task' do
    before do
      Timecop.freeze
    end

    after do
      Timecop.return
    end

    let(:member) { build_stubbed :member}
    let(:old_pha) { build_stubbed :pha, first_name: 'A', last_name: 'B'}
    let(:new_pha) { build_stubbed :pha}
    let!(:task) { create :task, member: member, owner: new_pha, assignor: old_pha, visible_in_queue: true}

    it 'should create a new task' do
      ViewTaskTask.should_receive(:create!).with(assigned_task: task,
                                                 title: "Task assigned to you by #{task.assignor.first_name} #{task.assignor.last_name}",
                                                 member: task.member,
                                                 creator: Member.robot,
                                                 assignor: task.assignor,
                                                 owner: task.owner,
                                                 due_at: Time.now,
                                                 priority: 7)
      ViewTaskTask.create_task_for_task(task)
    end

    it 'should set the original task to be not visible in queue' do
      ViewTaskTask.create_task_for_task(task)
      task.visible_in_queue.should == false
    end
  end

  describe 'complete task' do
    let(:member) { build_stubbed :member}
    let(:old_pha) { build_stubbed :pha, first_name: 'A', last_name: 'B'}
    let(:new_pha) { build_stubbed :pha}
    let!(:task) { create :task, member: member, owner: new_pha, assignor: old_pha, visible_in_queue: false}
    let!(:view_task_task) { create :view_task_task, assigned_task: task}

    context 'ViewTaskTask is completed' do
      it 'should set the original task to be visible in queue' do
        view_task_task.complete
        task.visible_in_queue.should == true
      end
    end
  end
end
require 'spec_helper'

describe MemberTask do
  it_has_a 'valid factory'

  describe 'validations' do
    it_validates 'foreign key of', :member
    it_validates 'foreign key of', :subject
    it_validates 'foreign key of', :service_type
  end

  describe '#publish' do
    let(:task) { build(:member_task) }

    context 'new record' do
      before do
        task.stub(:id) { 2 }
        task.stub(:id_changed?) { true }
        task.stub(:member_id) { 1 }
        task.stub(:subject_id) { 5 }
      end

      it 'publishes that a new task was created' do
        PubSub.should_receive(:publish).with(
          "/tasks/new",
          {id: task.id},
          nil
        )
        PubSub.should_receive(:publish).with(
          "/members/1/subjects/5/tasks/new",
          {id: task.id},
          nil
        )
        task.publish
      end
    end

    context 'old record' do
      before do
        task.stub(:id) { 2 }
        task.stub(:id_changed?) { false }
        task.stub(:member_id) { 1 }
        task.stub(:subject_id) { 5 }
      end

      it 'publishes that a task was updated' do
        PubSub.should_receive(:publish).with(
          "/tasks/update",
          {id: task.id},
          nil
        )
        PubSub.should_receive(:publish).with(
          "/tasks/2/update",
          {id: task.id},
          nil
        )
        PubSub.should_receive(:publish).with(
          "/members/1/subjects/5/tasks/update",
          {id: task.id},
          nil
        )
        task.publish
      end
    end
  end

  describe '#publish' do
    let(:task) { build(:member_task) }

    context 'new record' do
      before do
        task.stub(:id) { 2 }
        task.stub(:id_changed?) { true }
        task.stub(:member_id) { 1 }
        task.stub(:subject_id) { 5 }
      end

      it 'publishes that a new task was created' do
        PubSub.should_receive(:publish).with(
          "/tasks/new",
          {id: task.id},
          nil
        )
        PubSub.should_receive(:publish).with(
          "/members/1/subjects/5/tasks/new",
          {id: task.id},
          nil
        )
        task.publish
      end
    end

    context 'old record' do
      before do
        task.stub(:id) { 2 }
        task.stub(:id_changed?) { false }
        task.stub(:member_id) { 1 }
        task.stub(:subject_id) { 5 }
      end

      it 'publishes that a task was updated' do
        PubSub.should_receive(:publish).with(
          "/tasks/update",
          {id: task.id},
          nil
        )
        PubSub.should_receive(:publish).with(
          "/tasks/2/update",
          {id: task.id},
          nil
        )
        PubSub.should_receive(:publish).with(
          "/members/1/subjects/5/tasks/update",
          {id: task.id},
          nil
        )
        task.publish
      end
    end
  end
end

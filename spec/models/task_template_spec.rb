require 'spec_helper'

describe TaskTemplate do
  it_has_a 'valid factory'

  describe 'validations' do
    it_validates 'presence of', :name
    it_validates 'presence of', :title
  end

  describe '#create_task!' do
    let(:task_template) { build_stubbed :task_template }
    let(:task) { build :member_task }
    let(:pha) { build_stubbed :pha }
    let(:other_pha) { build_stubbed :pha }

    before do
      Timecop.freeze
    end

    after do
      Timecop.return
    end

    it 'creates a member task from it\'s own attributes' do
      MemberTask.should_receive(:create!).with(hash_including(
        title: task_template.title,
        description: task_template.description,
        due_at: Time.now.business_minutes_from(task_template.time_estimate.to_i),
        service_ordinal: task_template.service_ordinal
      )) { task }

      task_template.create_task!.should == task
    end

    it 'has the task reference back to the task template' do
      MemberTask.should_receive(:create!).with(hash_including(
        task_template: task_template
      )) { task }

      task_template.create_task!.should == task
    end

    context 'owner is set' do
      it 'sets the assignor to creator if missing' do
        MemberTask.should_receive(:create!).with(hash_including(
          assignor: other_pha
        )) { task }

        task_template.create_task!(owner: pha, creator: other_pha).should == task
      end

      it 'sets the assignor' do
        MemberTask.should_receive(:create!).with(hash_including(
          assignor: other_pha
        )) { task }

        task_template.create_task!(owner: pha, creator: pha, assignor: other_pha).should == task
      end
    end

    context 'owner is not set' do
      it 'sets the assignor to nil' do
        MemberTask.should_receive(:create!).with(hash_including(
          assignor: nil
        )) { task }

        task_template.create_task!(creator: pha, assignor: other_pha).should == task
      end
    end

    context 'service is in attributes' do
      let(:service) { build_stubbed :service }

      it 'sets the service from attributes' do
        MemberTask.should_receive(:create!).with(hash_including(
          service: service
        )) { task }

        task_template.create_task!(service: service).should == task
      end

      it 'sets other attributes from the service' do
        MemberTask.should_receive(:create!).with(hash_including(
          service_type: service.service_type,
          member: service.member,
          subject: service.subject
        )) { task }

        task_template.create_task!(service: service).should == task
      end
    end

    context 'no service is added' do
      let(:service_type) { build_stubbed :service_type }
      let(:member) { build_stubbed :member }
      let(:subject) { build_stubbed :user }

      it 'sets attributes from those passed in' do
        MemberTask.should_receive(:create!).with(hash_including(
          service_type: service_type,
          member: member,
          subject: subject
        )) { task }

        task_template.create_task!(service_type: service_type, member: member, subject: subject).should == task
      end
    end

    it 'uses attributes passed in first before it\'s own' do
      attributes = {
        title: task_template.title + ' B',
        description: task_template.description + ' B',
        start_at: 4.days.ago
      }

      MemberTask.should_receive(:create!).with(hash_including(
        title: attributes[:title],
        description: attributes[:description],
        due_at: 4.days.ago.business_minutes_from(task_template.time_estimate.to_i)
      )) { task }

      task_template.create_task!(attributes).should == task
    end

    it 'creates a valid task' do
      task_template = create :task_template
      service = create :service

      task = task_template.create_task! service: service
      task.should be_valid
      task.id.should be_present
    end
  end

  describe '#create_deep_copy!' do
    let(:task_template) { build_stubbed(:task_template)}

    it 'creates a deep copy of the current task template' do
      task_template.should_receive(:create_deep_copy!) { task_template }

      task_template.create_deep_copy!.should == task_template
    end
  end
end

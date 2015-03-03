require 'spec_helper'

describe Service do
  it_has_a 'valid factory'

  describe 'validations' do
    it_validates 'presence of', :title
    it_validates 'presence of', :service_type
    it_validates 'presence of', :state
    it_validates 'presence of', :member
    it_validates 'presence of', :creator
    it_validates 'presence of', :owner
    it_validates 'presence of', :assignor
    it_validates 'foreign key of', :service_template

    its 'validates presence of assigned_at' do
      service = build_stubbed :service
      service.stub(:owner_id_changed?) { false }
      service.assigned_at = nil
      service.should_not be_valid
      service.errors[:assigned_at].should include("can't be blank")
    end
  end

  describe '#set_assigned_at' do
    let(:service) { build :service }

    before do
      Timecop.freeze
    end

    after do
      Timecop.return
    end

    context 'owner id changed' do
      before do
        service.stub(:owner_id_changed?) { true }
      end

      it 'sets assigned at' do
        service.set_assigned_at
        service.assigned_at.should == Time.now
      end
    end

    context 'owner id not changed' do
      before do
        service.assigned_at = nil
        service.stub(:owner_id_changed?) { false }
      end

      it 'sets assigned at to' do
        service.set_assigned_at
        service.assigned_at.should be_nil
      end
    end
  end

  context '#actor_id' do
    let(:service) { build :service }

    context '@actor_id is not nil' do
      before do
        service.instance_variable_set('@actor_id', 2)
      end

      it 'returns @actor_id' do
        service.actor_id.should == 2
      end
    end

    context 'actor_id is nil' do
      before do
        service.instance_variable_set('@actor_id', nil)
      end

      context 'owner_id is not nil' do
        before do
          service.stub(:owner_id) { 2 }
        end

        it 'returns owner_id' do
          service.actor_id.should == 2
        end
      end

      context 'owner_id is nil' do
        before do
          service.stub(:owner_id) { nil }
        end

        it 'returns creator id' do
          service.stub(:creator_id) { 3 }
          service.actor_id.should == 3
        end
      end
    end
  end

  describe '#tasks' do
    let!(:service) { create :service }
    let!(:first_task) { create :task, service: service, service_ordinal: 0 }
    let!(:second_task) { create :task, service: service, service_ordinal: 1 }
    let!(:third_task) { create :task, service: service, service_ordinal: 2 }
    let!(:fourth_task) { create :task, service: service, service_ordinal: 3, priority: 2, due_at: 5.days.from_now }
    let!(:fifth_task) { create :task, service: service, service_ordinal: 3, due_at: 4.days.from_now }

    it 'returns all tasks for the service' do
      tasks = service.tasks
      tasks.should be_include(first_task)
      tasks.should be_include(second_task)
      tasks.should be_include(third_task)
      tasks.should be_include(fourth_task)
      tasks.should be_include(fifth_task)
    end

    it 'returns all tasks sorted by service ordinal' do
      service.tasks.should == [first_task, second_task, third_task, fourth_task, fifth_task]
    end
  end

  describe '#track_update' do
    let!(:service) { create :service }

    before do
      ServiceChange.destroy_all
    end

    context 'change was tracked' do
      before do
        service.change_tracked = true
      end

      it 'doesn\'t create a service change' do
        ServiceChange.should_not_receive(:create!)
        service.send(:track_update)
      end

      it 'sets change_tracked to false' do
        service.send(:track_update)
        expect(service.change_tracked).to equal(false)
      end
    end

    context 'nothing changed' do
      context 'because no changes were made' do
        it 'does nothing' do
          service.stub(:previous_changes) { service.changes }
          ServiceChange.should_not_receive(:create!)
          service.send(:track_update)
        end
      end

      context 'because only filtered out attributes changed' do
        before do
          service.created_at = 4.days.ago
          service.updated_at = 3.days.ago
          service.assigned_at = 3.days.ago
          service.completed_at = 2.days.ago
          service.abandoned_at = 10.days.ago
          service.assignor_id = 2
          service.abandoner_id = 5
          service.creator_id = 3
          service.state = 'unstarted'
          service.stub(:previous_changes) { service.changes }
        end

        it 'does nothing' do
          ServiceChange.should_not_receive(:create!)
          service.send(:track_update)
        end
      end
    end

    context 'something changed' do
      it 'it tracks a change after a the description is changed' do
        old_description = service.description
        old_title = service.title
        service.update_attributes!(description: 'poop', title: 'shit')
        ServiceChange.count.should == 1
        t = ServiceChange.last
        t.service.should == service
        t.event.should == 'update'
        t.data.should == {"description" => [old_description, 'poop'], "title" => [old_title, 'shit']}
      end

      context 'actor_id is defined' do
        let(:pha) { build_stubbed :pha }

        before do
          service.actor_id = pha.id
          service.title = 'Poop'
          service.stub(:previous_changes) { service.changes }
        end

        it 'uses the defined actor id' do
          ServiceChange.should_receive(:create!).with hash_including(actor_id: pha.id)
          service.send(:track_update)
        end
      end
    end
  end
end

require 'spec_helper'

describe Task do
  it_has_a 'valid factory'

  before do
    @pha_id = Role.find_or_create_by_name!(:pha).id
  end

  describe 'validations' do
    it_validates 'presence of', :title
    it_validates 'presence of', :state
    it_validates 'presence of', :role_id
    it_validates 'presence of', :creator_id
    it_validates 'foreign key of', :owner
    it_validates 'foreign key of', :role

    describe '#one_claimed_per_owner' do
      let(:claimed_task) { build_stubbed :task, :claimed }

      context 'task is claimed' do
        let(:task) { build :task, :claimed }

        it 'fails if another claimed task exists for the owner' do
          Task.stub(:find_by_owner_id_and_state).with(task.owner_id, 'claimed') { claimed_task }
          task.should_not be_valid
        end

        it 'passes if no other claimed task exists for the owner' do
          Task.stub(:find_by_owner_id_and_state).with(task.owner_id, 'claimed') { nil }
          task.should be_valid
        end

        it 'passes if the other claimed task is this task' do
          task = build_stubbed :task, :claimed, role_id: @pha_id
          Task.stub(:find_by_owner_id_and_state).with(task.owner_id, 'claimed') { task }
          task.should be_valid
        end
      end

      context 'task is not claimed' do
        let(:task) { build :task, :started }

        it 'passes if another claimed tasks exists for the owner' do
          Task.stub(:find_by_owner_id_and_state).with(task.owner_id, 'claimed') { claimed_task }
          task.should be_valid
        end
      end
    end

  end

  describe '#open?' do
    let(:task) { build :task }

    it 'returns true when unassigned' do
      task.state = 'unassigned'
      task.should be_open
    end

    it 'returns true when assigned' do
      task.state = 'assigned'
      task.should be_open
    end

    it 'returns true when started' do
      task.state = 'started'
      task.should be_open
    end

    it 'returns true when claimed' do
      task.state = 'claimed'
      task.should be_open
    end

    it 'returns false when completed' do
      task.state = 'completed'
      task.should_not be_open
    end

    it 'returns false when abandoned' do
      task.state = 'abandoned'
      task.should_not be_open
    end
  end

  describe '#for_nurse?' do
    let(:task) { build :task }

    it 'returns true when task is for nurse' do
      task.stub(:role) { build(:role, name: 'nurse') }
      task.should be_for_nurse
    end

    it 'returns false when task is not for nurse' do
      task.stub(:role) { build(:role, name: 'pha_lead') }
      task.should_not be_for_nurse
    end
  end

  describe '#for_pha?' do
    let(:task) { build :task }

    it 'returns true when task is for pha' do
      task.stub(:role) { build(:role, name: 'pha') }
      task.should be_for_pha
    end

    it 'returns false when task is not for pha' do
      task.stub(:role) { build(:role, name: 'nurse') }
      task.should_not be_for_pha
    end
  end

  describe '#open' do
    it 'returns tasks that are still open' do
      unassigned_task = create(:task)
      assigned_task = create(:task, :assigned)
      started_task = create(:task, :started)
      claimed_task = create(:task, :claimed)
      completed_task = create(:task, :completed)
      abandoned_task = create(:task, :abandoned)

      open_tasks = Task.open

      open_tasks.should be_include(unassigned_task)
      open_tasks.should be_include(assigned_task)
      open_tasks.should be_include(started_task)
      open_tasks.should be_include(claimed_task)
      open_tasks.should_not be_include(completed_task)
      open_tasks.should_not be_include(abandoned_task)
    end
  end

  describe '#set_role' do
    let(:task) { build :task }

    context 'role_id is nil' do
      it 'sets it to pha' do
        task.set_role
        task.role_id.should == @pha_id
      end
    end

    context' role_id is present' do
      before do
        task.stub(:role_id) { 2 }
      end

      it 'does nothing' do
        task.should_not_receive(:role_id=)
        task.set_role
      end
    end
  end

  describe '#publish' do
    let(:task) { build(:task) }

    context 'is called after' do
      it 'create' do
        task.should_receive(:publish)
        task.save!
      end

      it 'update' do
        task.save!
        task.should_receive(:publish)
        task.save!
      end
    end

    context 'new record' do
      before do
        task.stub(:id_changed?) { true }
      end

      it 'publishes that a new phone call was created' do
        PubSub.should_receive(:publish).with(
          "/tasks/new",
          {id: task.id}
        )
        task.publish
      end
    end

    context 'old record' do
      let(:task) { build_stubbed(:task) }

      before do
        task.stub(:id_changed?) { false }
      end

      it 'publishes that a phone call was updated' do
        PubSub.should_receive(:publish).with(
          "/tasks/update",
          { id: task.id }
        )
        PubSub.should_receive(:publish).with(
          "/tasks/#{task.id}/update",
          {id: task.id}
        )
        task.publish
      end
    end
  end

  describe 'states' do
    let(:task) { build :task }
    let(:pha) { build_stubbed :pha }
    let(:pha_lead) { build_stubbed :pha_lead }

    before do
      Timecop.freeze
    end

    after do
      Timecop.return
    end

    it 'has an initial state of unassigned' do
      task.should be_unassigned
    end

    describe '#unassign' do
      let(:task) { build :task, :assigned }

      it_behaves_like 'cannot transition from', :unassign!, [:started, :claimed, :abandoned, :completed]

      it 'changes state to unassigned' do
        task.should_not be_unassigned
        task.unassign!
        task.should be_unassigned
      end

      it 'removes assignor' do
        task.assignor.should be_present
        task.unassign!
        task.assignor.should_not be_present
      end

      it 'removes owner' do
        task.owner.should be_present
        task.unassign!
        task.owner.should_not be_present
      end
    end

    describe '#assign' do
      let(:task) { build :task }

      it_behaves_like 'cannot transition from', :unassign!, [:started, :claimed, :abandoned, :completed]

      it 'changes state to assigned' do
        task.should_not be_assigned
        task.update_attributes! state_event: :assign, owner: pha, assignor: pha_lead
        task.should be_assigned
      end

      it 'sets assigned at' do
        task.assigned_at.should be_nil
        task.update_attributes! state_event: :assign, owner: pha, assignor: pha_lead
        task.assigned_at.should == Time.now
      end
    end

    describe '#start' do
      let(:task) { build :task, :assigned }

      it 'changes state to started' do
        task.should_not be_started
        task.start!
        task.should be_started
      end

      it 'sets started at' do
        task.started_at.should be_nil
        task.start!
        task.started_at.should == Time.now
      end
    end

    describe '#claim' do
      let(:task) { build :task }

      it_behaves_like 'cannot transition from', :unassign!, [:claimed]

      it 'changes state to claimed' do
        task.should_not be_claimed
        task.owner = pha
        task.claim!
        task.should be_claimed
      end

      it 'sets claimed at' do
        task.claimed_at.should be_nil
        task.owner = pha
        task.claim!
        task.claimed_at.should == Time.now
      end
    end

    describe '#complete' do
      let(:task) { build :task, :claimed }

      it 'changes state to completed' do
        task.should_not be_completed
        task.owner = pha
        task.complete!
        task.should be_completed
      end

      it 'sets completed at' do
        task.completed_at.should be_nil
        task.complete!
        task.completed_at.should == Time.now
      end
    end

    describe '#abandon' do
      let(:task) { build :task, :claimed }

      it 'changes state to abandoned' do
        task.should_not be_abandoned
        task.abandoner = pha
        task.reason_abandoned = 'pooed'
        task.abandon!
        task.should be_abandoned
      end

      it 'sets abandoned at' do
        task.completed_at.should be_nil
        task.abandoner = pha
        task.reason_abandoned = 'pooed'
        task.abandon!
        task.abandoned_at.should == Time.now
      end
    end
  end
end

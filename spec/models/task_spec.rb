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
    it_validates 'presence of', :due_at
    it_validates 'presence of', :priority
    it_validates 'foreign key of', :owner
    it_validates 'foreign key of', :role
    it_validates 'foreign key of', :service_type

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

    it 'returns true when unstarted' do
      task.state = 'unstarted'
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
      unstarted_task = create(:task)
      assigned_task = create(:task, :assigned)
      started_task = create(:task, :started)
      claimed_task = create(:task, :claimed)
      completed_task = create(:task, :completed)
      abandoned_task = create(:task, :abandoned)

      open_tasks = Task.open

      open_tasks.should be_include(unstarted_task)
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

  describe '#set_priority' do
    let(:task) { build :task }

    it 'sets it to zero' do
      task.set_priority
      task.priority.should == 0
    end
  end

  describe '#set_assigned_at' do
    let(:task) { build :task }

    before do
      Timecop.freeze
    end

    after do
      Timecop.return
    end

    context 'owner id changed' do
      before do
        task.stub(:owner_id_changed?) { true }
      end

      it 'sets assigned at' do
        task.set_assigned_at
        task.assigned_at.should == Time.now
      end
    end

    context 'owner id not changed' do
      before do
        task.stub(:owner_id_changed?) { false }
      end

      it 'sets assigned at to' do
        task.set_assigned_at
        task.assigned_at.should be_nil
      end
    end
  end

  describe '#notify' do
    let(:task) { build :task }
    let(:pha) { build :pha }
    let(:delayed_user_mailer) { double('delay') }

    before do
      UserMailer.stub(:delay) { delayed_user_mailer }
    end

    context 'task is not for pha' do
      before do
        task.stub(:for_pha?) { false }
        task.stub(:owner_id_changed?) { true }
        task.stub(:state_changed?) { true }
        task.stub(:abandoned?) { true }
        task.owner_id { Member.robot.id + 1 }
      end

      it 'does nothing' do
        UserMailer.should_not_receive :delay
        task.notify
      end
    end

    context 'task is for pha' do
      before do
        task.stub(:for_pha?) { true }
      end

      context 'owner_id changed' do
        before do
          task.stub(:owner_id_changed?) { true }
        end

        context 'unassigned' do
          let(:phas) { [build_stubbed(:pha), build_stubbed(:pha), build_stubbed(:pha)] }

          before do
            task.stub(:unassigned?) { true }
            Role.stub_chain(:pha, :users) do
              o = Object.new
              o.stub(:where).with(on_call: true) { phas }
              o
            end
          end

          it 'sends an email to all on call phas' do
            delayed_user_mailer.should_receive(:notify_of_unassigned_task).with task, phas[0]
            delayed_user_mailer.should_receive(:notify_of_unassigned_task).with task, phas[1]
            delayed_user_mailer.should_receive(:notify_of_unassigned_task).with task, phas[2]

            task.notify
          end
        end

        context 'has owner' do
          before do
            task.stub(:unassigned?) { false }
            task.stub(:owner) { pha }
          end

          it 'sends an email to the owner of the task' do
            delayed_user_mailer.should_receive(:notify_of_assigned_task).with task, pha
            task.notify
          end
        end
      end

      context 'owner id did not change' do
        before do
          task.stub(:owner_id_changed?) { false }
        end

        it 'does nothing' do
          UserMailer.should_not_receive :delay
          task.notify
        end
      end

      context 'state changed?' do
        before do
          task.stub(:state_changed?) { true }
        end

        context 'abandoned' do
          before do
            task.stub(:abandoned?) { true }
          end

          context 'abandoner is not robot' do
            let(:pha_leads) { [build(:pha_lead), build(:pha_lead)] }

            before do
              task.stub(:abandoner_id) { Member.robot.id + 1 }
              task.stub(:abandoner) { pha }
            end

            it 'notifies the owner' do
              task.stub(:owner) { pha }
              delayed_user_mailer.should_receive(:notify_of_abandoned_task).with task, pha
              task.notify
            end

            it 'notifies the leads' do
              Role.stub_chain(:pha_lead, :users) { pha_leads }

              delayed_user_mailer.should_receive(:notify_of_abandoned_task).with task, pha_leads[0]
              delayed_user_mailer.should_receive(:notify_of_abandoned_task).with task, pha_leads[1]
              task.notify
            end
          end

          context 'abandoner is robot' do
            before do
              task.stub(:abandoner_id) { Member.robot.id }
              task.stub(:abandoner) { Member.robot }
            end

            it 'does nothing' do
              UserMailer.should_not_receive :delay
              task.notify
            end
          end
        end

        context 'not abandoned' do
          before do
            task.stub(:abandoned?) { false }
          end

          it 'does nothing' do
            UserMailer.should_not_receive :delay
            task.notify
          end
        end
      end

      context 'state did not change' do
        before do
          task.stub(:state_changed?) { false }
        end

        it 'does nothing' do
          UserMailer.should_not_receive :delay
          task.notify
        end
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
          { id: task.id }
        )
        task.publish
      end
    end

    context 'owner id is present' do
      let(:task) { build_stubbed(:task) }

      before do
        task.stub(:owner_id) { 3 }
      end

      it 'published to the owners channel' do
        PubSub.should_receive(:publish).with('/tasks/new', { id: task.id })
        PubSub.should_receive(:publish).with(
          "/users/3/tasks/owned/update",
          { id: task.id }
        )
        task.publish
      end
    end

    context 'owner id changed' do
      let(:task) { build_stubbed(:task) }

      before do
        task.stub(:owner_id_changed?) { true }
      end

      context 'there was a previous owner' do
        before do
          task.stub(:owner_id_was) { '2' }
        end

        it 'publishes to the old owners channel' do
          PubSub.should_receive(:publish).with('/tasks/new', { id: task.id })
          PubSub.should_receive(:publish).with(
            "/users/2/tasks/owned/update",
            { id: task.id }
          )
          task.publish
        end
      end

      context 'there is not previous owner' do
        before do
          task.stub(:owner_id_was) { nil }
        end

        it 'publishes to the old owners channel' do
          PubSub.should_receive(:publish).with('/tasks/new', { id: task.id })
          PubSub.should_not_receive(:publish).with(
            "/users//tasks/owned/update",
            { id: task.id }
          )
          task.publish
        end
      end
    end
  end

  describe 'scopes' do
    let!(:pha) { create :pha }
    let!(:other_pha) { create :pha }
    let!(:task_1) { create :member_task, :assigned, owner: pha }
    let!(:task_2) { create :member_task }
    let!(:task_3) { create :member_task }
    let!(:task_4) { create :member_task, :started, owner: pha }
    let!(:task_5) { create :member_task, :assigned, owner: other_pha }
    let!(:task_6) { create :member_task, :abandoned }
    let!(:task_7) { create :message_task, :assigned, owner: pha }
    let!(:task_8) { create :phone_call_task, :assigned, owner: pha }
    let!(:task_9) { create :message_task }
    let!(:task_10) { create :phone_call_task }

    describe '#owned' do
      it 'returns owned tasks' do
        tasks = Task.owned(pha)
        tasks.should be_include(task_1)
        tasks.should_not be_include(task_2)
        tasks.should_not be_include(task_3)
        tasks.should be_include(task_4)
        tasks.should_not be_include(task_5)
        tasks.should_not be_include(task_6)
        tasks.should be_include(task_7)
        tasks.should be_include(task_8)
        tasks.should_not be_include(task_9)
        tasks.should_not be_include(task_10)
      end
    end

    describe '#needs_triage' do
      it 'returns tasks that are unassigned or assigned inbound tasks' do
        tasks = Task.needs_triage(pha)
        tasks.should_not be_include(task_1)
        tasks.should be_include(task_2)
        tasks.should be_include(task_3)
        tasks.should_not be_include(task_4)
        tasks.should_not be_include(task_5)
        tasks.should_not be_include(task_6)
        tasks.should be_include(task_7)
        tasks.should be_include(task_8)
        tasks.should be_include(task_9)
        tasks.should be_include(task_10)
      end
    end

    describe '#needs_triage_or_owned' do
      it 'returns tasks that are unassigned or assigned inbound tasks' do
        tasks = Task.needs_triage_or_owned(pha)
        tasks.should be_include(task_1)
        tasks.should be_include(task_2)
        tasks.should be_include(task_3)
        tasks.should be_include(task_4)
        tasks.should_not be_include(task_5)
        tasks.should_not be_include(task_6)
        tasks.should be_include(task_7)
        tasks.should be_include(task_8)
        tasks.should be_include(task_9)
        tasks.should be_include(task_10)
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

    it 'has an initial state of unstarted' do
      task.should be_unstarted
    end

    describe '#unstart' do
      let(:task) { build :task, :started }

      it 'changes state to unstarted' do
        task.should_not be_unstarted
        task.unstart!
        task.should be_unstarted
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
      let(:task) { build :task, assignor: pha }

      it_behaves_like 'cannot transition from', :claim!, [:claimed]

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

  describe '#set_owner' do
    let(:task) { build :task }

    before do
      Timecop.freeze
    end

    after do
      Timecop.return
    end

    context 'member doesn\'t exist' do
      before do
        task.stub(:member) { nil }
      end

      it 'does nothing' do
        task.set_owner
        task.owner.should be_nil
        task.assignor.should be_nil
        task.assigned_at.should be_nil
      end
    end

    context 'member exists' do
      let(:member) { build :member }

      before do
        task.stub(:member) { member }
      end

      context 'member doesn\'t have a pha' do
        before do
          member.stub(:pha) { nil }
        end

        it 'does nothing' do
          task.set_owner
          task.owner.should be_nil
          task.assignor.should be_nil
          task.assigned_at.should be_nil
        end
      end

      context 'member has a pha' do
        let(:pha) { build :pha }
        before do
          member.stub(:pha) { pha }
        end

        it 'sets owner to pha' do
          task.set_owner
          task.owner.should == pha
        end

        it 'sets the assignor to the robot' do
          task.set_owner
          task.assignor.should == Member.robot
        end

        it 'sets the assigned at' do
          task.set_owner
          task.assigned_at.should == Time.now
        end
      end
    end
  end
end

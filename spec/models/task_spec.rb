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
    it_validates 'inclusion of', :urgent
    it_validates 'inclusion of', :unread
    it_validates 'inclusion of', :follow_up
    it_validates 'foreign key of', :owner
    it_validates 'foreign key of', :role
    it_validates 'foreign key of', :service_type
    it_validates 'foreign key of', :task_template
    it_validates 'foreign key of', :member

    describe 'validate priority' do
      before do
        described_class.any_instance.stub(:update_priority_score)
      end
      it_validates 'presence of', :priority
    end

    describe '#service' do
      let(:task) { build :task }

      context 'service id exists' do
        before do
          task.stub(:service_id) { 1 }
        end

        it 'validates presence' do
          task.stub(:service) { nil }
          task.should_not be_valid
          task.errors[:service].should include("can't be blank")
        end
      end

      context 'service id does not exist' do
        before do
          task.stub(:service_id) { nil }
          task.role = build_stubbed :role
        end

        it "doesn't validate presence" do
          task.stub(:service) { nil }
          task.should be_valid
        end
      end
    end

    describe '#service_ordinal' do
      let(:task) { build :task }

      context 'service id exists' do
        before do
          task.stub(:service_id) { 1 }
        end

        it 'validates presence' do
          task.service_ordinal = nil
          task.should_not be_valid
          task.errors[:service_ordinal].should include("can't be blank")
        end
      end

      context 'service id does not exist' do
        before do
          task.stub(:service_id) { nil }
          task.role = build_stubbed :role
        end

        it "doesn't validate presence" do
          task.service_ordinal = 1
          task.should be_valid
        end
      end
    end

    describe 'presence of reason' do
      let(:task) { build :task }

      context 'neither abandoned nor due at changed' do
        before do
          task.stub(:due_at_changed?) { false }
          task.stub(:state_changed?) { false }
        end

        it 'doesn\'t need to be present' do
          task.reason.should_not be_present
          task.should be_valid
        end
      end

      context 'state changed' do
        before do
          task.stub(:state_changed?) { true }
        end

        context 'not transitioning to abandoned' do
          before do
            task.stub(:abandoned?) { false }
          end

          it 'doesn\'t need to be present' do
            task.reason.should_not be_present
            task.should be_valid
          end
        end

        context 'transitioning to abandoned' do
          before do
            task.stub(:abandoned?) { true }
          end

          it 'needs to be present' do
            task.reason.should_not be_present
            task.should_not be_valid
          end
        end
      end

      context 'due_at changed' do
        before do
          task.stub(:due_at_changed?) { true }
        end

        context 'due_at was nil' do
          before do
            task.stub(:due_at_was) { nil }
          end

          it 'doesn\'t need to be present' do
            task.reason.should_not be_present
            task.should be_valid
          end
        end

        context 'due_at was something else' do
          before do
            task.stub(:due_at_was) { 5.days.ago }
          end

          it 'needs to be present' do
            task.reason.should_not be_present
            task.should_not be_valid
          end
        end
      end
    end
  end

  describe '#open?' do
    let(:task) { build :task }

    it 'returns true when unclaimed' do
      task.state = 'unclaimed'
      task.should be_open
    end

    it 'returns true when blocked_internal' do
      task.state = 'blocked_internal'
      task.should be_open
    end

    it 'returns true when blocked_external' do
      task.state = 'blocked_external'
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
      assigned_task = create(:task, :assigned)
      unclaimed_task = create(:task, :unclaimed)
      claimed_task = create(:task, :claimed)
      blocked_internal_task = create(:task, :blocked_internal)
      blocked_external_task = create(:task, :blocked_external)
      completed_task = create(:task, :completed)
      abandoned_task = create(:task, :abandoned)

      open_tasks = Task.open

      open_tasks.should be_include(assigned_task)
      open_tasks.should be_include(unclaimed_task)
      open_tasks.should be_include(claimed_task)
      open_tasks.should be_include(blocked_internal_task)
      open_tasks.should be_include(blocked_external_task)
      open_tasks.should_not be_include(completed_task)
      open_tasks.should_not be_include(abandoned_task)
    end
  end

  describe '#mark_as_unread' do
    let(:task) { build :task, type: 'MemberTask' }
    let(:pha) { build :pha}

    context 'owner is a specialist' do
      before do
        task.stub(:owner_id_changed?) { true }
        pha.stub(:has_role?).with('pha') { true }
        pha.stub(:has_role?).with('specialist') { true }
        task.owner_id { specialist.id }
      end

      it 'does nothing' do
        task.mark_as_unread
        task.unread.should == false
      end
    end

    context 'owner is a pha' do
      before do
        pha.stub(:has_role?).with('pha') { true }
        pha.stub(:has_role?).with('specialist') { false }
      end

      context 'owner_id changed' do
        before do
          task.stub(:owner_id_changed?) { true }
        end

        context 'unassigned' do
          before do
            task.stub(:unassigned?) { true }
          end

          it 'does nothing' do
            task.mark_as_unread
            task.unread.should == false
          end
        end

        context 'has owner' do
          before do
            task.stub(:unassigned?) { false }
            task.stub(:owner) { pha }
          end

          context 'owner is assignor' do
            before do
              task.stub(:assignor_id) { 1 }
              task.stub(:owner_id) { 1 }
            end

            it 'does nothing' do
              task.mark_as_unread
              task.unread.should == false
            end
          end

          context 'owner is not assignor' do
            before do
              task.stub(:assignor_id) { 0 }
              task.stub(:owner_id) { 1 }
            end

            context 'task is urgent' do
              before do
                task.stub(:urgent?) { true }
              end

              it 'does nothing' do
                task.mark_as_unread
                task.unread.should == false
              end
            end

            context 'task is not urgent' do
              before do
                task.stub(:urgent) { false }
              end

              it 'marks as unread' do

                task.mark_as_unread
                task.unread.should == true
              end
            end
          end
        end
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

          context 'owner is assignor' do
            before do
              task.stub(:assignor_id) { 1 }
              task.stub(:owner_id) { 1 }
            end

            it 'does nothing' do
              UserMailer.should_not_receive :delay
              task.notify
            end
          end

          context 'owner is not assignor' do
            before do
              task.stub(:assignor_id) { 1 }
              task.stub(:owner_id) { 2 }
            end

            it 'sends an email to the owner of the task' do
              delayed_user_mailer.should_receive(:notify_of_assigned_task).with task, pha
              task.notify
            end
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
    let(:task) { build(:task, queue: :pha) }

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
        task.stub(:queue) { nil }
      end

      it 'publishes that a new phone call was created' do
        PubSub.should_receive(:publish).with(
          "/tasks/new",
          {id: task.id},
          nil
        )
        task.publish
      end
    end

    context 'old record' do
      let(:task) { build_stubbed(:task) }

      before do
        task.stub(:id_changed?) { false }
        task.stub(:queue) { nil }
      end

      it 'publishes that a phone call was updated' do
        PubSub.should_receive(:publish).with(
          "/tasks/update",
          { id: task.id },
          nil
        )
        PubSub.should_receive(:publish).with(
          "/tasks/#{task.id}/update",
          { id: task.id },
          nil
        )
        task.publish
      end
    end

    context 'owner id is present' do
      let(:task) { build_stubbed(:task) }

      before do
        task.stub(:owner_id) { 3 }
        task.stub(:queue) { nil }
      end

      it 'published to the owners channel' do
        PubSub.should_receive(:publish).with('/tasks/new', { id: task.id }, nil)
        PubSub.should_receive(:publish).with(
          "/users/3/tasks/owned/update",
          { id: task.id },
          nil
        )
        task.publish
      end
    end

    context 'owner id changed' do
      let(:task) { build_stubbed(:task) }

      before do
        task.stub(:owner_id_changed?) { true }
        task.stub(:queue) { nil }
      end

      context 'there was a previous owner' do
        before do
          task.stub(:owner_id_was) { '2' }
        end

        it 'publishes to the old owners channel' do
          PubSub.should_receive(:publish).with('/tasks/new', { id: task.id }, nil)
          PubSub.should_receive(:publish).with(
            "/users/2/tasks/owned/update",
            { id: task.id },
            nil
          )
          task.publish
        end
      end

      context 'there is not previous owner' do
        before do
          task.stub(:owner_id_was) { nil }
        end

        it 'publishes to the old owners channel' do
          PubSub.should_receive(:publish).with('/tasks/new', { id: task.id }, nil)
          PubSub.should_not_receive(:publish).with(
            "/users//tasks/owned/update",
            { id: task.id },
            nil
          )
          task.publish
        end
      end
    end

    it 'should publish to the tasks queue channel' do
      task.stub(:id_changed?) { true }
      PubSub.should_receive(:publish).with(
        "/tasks/new",
        {id: task.id},
        nil
      )
      PubSub.should_receive(:publish).with(
      '/tasks/queue/pha',
       { id: task.id }
      )
      task.publish
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

    it 'has an initial state of unclaimed' do
      task.should be_unclaimed
    end

    describe '#unclaim' do
      let(:task) { build :task, :claimed }

      it 'changes state to unclaimed' do
        task.should_not be_unclaimed
        task.unclaim!
        task.should be_unclaimed
      end

      it 'sets owner to nil' do
        task.owner = pha
        task.unclaim!
        task.owner_id.should be_nil
      end

      it 'indicates a change was tracked' do
        task.unclaim!
        expect(task.change_tracked).to be_true
      end
    end

    describe '#claim' do
      let(:task) { build :task}

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

      it 'indicates a change was tracked' do
        task.claimed_at.should be_nil
        task.owner = pha
        task.claim!
        expect(task.change_tracked).to be_true
      end
    end

    describe '#report_blocked_by_internal' do
      let(:task) { build :task, assignor: pha }

      it 'changes state to blocked_internal' do
        task.should_not be_blocked_internal
        task.owner = pha
        task.report_blocked_by_internal!
        task.should be_blocked_internal
      end

      it 'sets blocked internal at' do
        task.blocked_internal_at.should be_nil
        task.owner = pha
        task.report_blocked_by_internal!
        task.blocked_internal_at.should == Time.now
      end

      it 'indicates a change was tracked' do
        task.blocked_internal_at.should be_nil
        task.owner = pha
        task.report_blocked_by_internal!
        expect(task.change_tracked).to be_true
      end
    end

    describe '#report_blocked_by_external' do
      let(:task) { build :task, assignor: pha }

      it 'changes state to blocked_external' do
        task.should_not be_blocked_external
        task.owner = pha
        task.report_blocked_by_external!
        task.should be_blocked_external
      end

      it 'sets blocked external at' do
        task.blocked_external_at.should be_nil
        task.owner = pha
        task.report_blocked_by_external!
        task.blocked_external_at.should == Time.now
      end

      it 'indicates a change was tracked' do
        task.blocked_external_at.should be_nil
        task.owner = pha
        task.report_blocked_by_external!
        expect(task.change_tracked).to be_true
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

      it 'indicates a change was tracked' do
        task.complete!
        expect(task.change_tracked).to be_true
      end

      context 'the task is part of a service' do
        let!(:service_template) { create :service_template}
        let!(:service) { create :service, service_template: service_template }
        let(:service_task) { build :task, :claimed, service: service, service_ordinal: 0 }

        context 'there are tasks in the service template with a higher ordinal' do
          let!(:task_template) { create :task_template, service_template: service_template, service_ordinal: 2}
          let!(:task_template_higher) { create :task_template, service_template: service_template, service_ordinal: 3}

          context 'the completed task is the last task in its ordinal' do
            it 'should create the tasks with the next ordinal' do
              service.should_receive(:create_next_ordinal_tasks)
              service_task.complete!
            end
          end

          context 'the completed task is not the last task in its ordinal' do
            let!(:another_service_task) { create :task, :claimed, service: service, service_ordinal: 0 }
            it 'should not create any tasks' do
              Task.should_not_receive(:create!)
              service_task.complete!
            end
          end
        end
      end
    end

    describe '#abandon' do
      let(:task) { build :task, :claimed }

      it 'changes state to abandoned' do
        task.should_not be_abandoned
        task.abandoner = pha
        task.reason = 'pooed'
        task.abandon!
        task.should be_abandoned
      end

      it 'sets abandoned at' do
        task.completed_at.should be_nil
        task.abandoner = pha
        task.reason = 'pooed'
        task.abandon!
        task.abandoned_at.should == Time.now
      end

      it 'indicates a change was tracked' do
        task.completed_at.should be_nil
        task.abandoner = pha
        task.reason = 'pooed'
        task.abandon!
        expect(task.change_tracked).to be_true
      end
    end
  end

  describe '#actor_id' do
    let(:task) { build_stubbed :task }

    context '@actor_id is set' do
      before do
        task.actor_id = 1
      end

      it 'returns @actor_id' do
        task.actor_id.should == 1
      end
    end

    context '@actor_id is not set' do
      before do
        task.actor_id = nil
      end

      it 'returns @actor_id' do
        task.actor_id.should == Member.robot.id
      end
    end
  end

  describe '#track_update' do
    let!(:task) { create :member_task }

    before do
      TaskChange.destroy_all
    end

    context 'change was tracked' do
      before do
        task.change_tracked = true
      end

      it 'doesn\'t create a task change' do
        TaskChange.should_not_receive(:create!)
        task.send(:track_update)
      end

      it 'sets change_tracked to false' do
        task.send(:track_update)
        expect(task.change_tracked).to equal(false)
      end
    end

    context 'nothing changed' do
      context 'because no changes were made' do
        it 'does nothing' do
          task.stub(:previous_changes) { task.changes }
          TaskChange.should_not_receive(:create!)
          task.send(:track_update)
        end
      end

      context 'because only filtered out attributes changed' do
        before do
          task.created_at = 4.days.ago
          task.unclaimed_at = 4.days.ago
          task.updated_at = 3.days.ago
          task.assigned_at = 3.days.ago
          task.claimed_at = 1.days.ago
          task.blocked_internal_at = 1.days.ago
          task.blocked_external_at = 1.days.ago
          task.completed_at = 2.days.ago
          task.abandoned_at = 10.days.ago
          task.assignor_id = 2
          task.abandoner_id = 5
          task.creator_id = 3
          task.state = 'unclaimed'
          task.visible_in_queue = true
          task.stub(:previous_changes) { task.changes }
        end

        it 'does nothing' do
          TaskChange.should_not_receive(:create!)
          task.send(:track_update)
        end
      end
    end

    context 'something changed' do
      it 'it tracks a change after a condition is added to a user' do
        old_description = task.description
        old_title = task.title
        task.update_attributes!(description: 'poop', title: 'shit')
        TaskChange.count.should == 1
        t = TaskChange.last
        t.task.should == task
        t.actor.should == Member.robot
        t.event.should == 'update'
        t.data.should == {"description" => [old_description, 'poop'], "title" => [old_title, 'shit']}
      end

      context 'actor_id is defined' do
        let(:pha) { build_stubbed :pha }

        before do
          task.actor_id = pha.id
          task.title = 'Poop'
          task.stub(:previous_changes) { task.changes }
        end

        it 'uses the defined actor id' do
          TaskChange.should_receive(:create!).with hash_including(actor_id: pha.id)
          task.send(:track_update)
        end
      end
    end
  end
end

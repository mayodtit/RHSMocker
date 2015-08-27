require 'spec_helper'

describe Service do
  it_has_a 'valid factory'

  describe 'validations' do
    it_validates 'presence of', :title
    it_validates 'presence of', :service_type
    it_validates 'presence of', :state
    it_validates 'presence of', :member
    it_validates 'presence of', :subject
    it_validates 'presence of', :creator
    it_validates 'presence of', :owner
    it_validates 'presence of', :assignor
    it_validates 'foreign key of', :service_template
    it_validates 'foreign key of', :suggested_service

    it 'validates presence of assigned_at' do
      service = build_stubbed :service
      service.stub(:owner_id_changed?) { false }
      service.assigned_at = nil
      service.should_not be_valid
      service.errors[:assigned_at].should include("can't be blank")
    end

    describe '#no_brackes_in_user_facing_attributes' do
      let(:service) { build(:service) }

      it 'prevents brackets the title' do
        service.title = "This has a [placeholder]"
        expect(service).to_not be_valid
        expect(service.errors[:title]).to include("shouldn't contain placeholder text")
      end

      it 'prevents brackets in the service_request' do
        service.service_request = "This has a [placeholder]"
        expect(service).to_not be_valid
        expect(service.errors[:service_request]).to include("shouldn't contain placeholder text")
      end

      it 'prevents brackets in the service_deliverable' do
        service.service_deliverable = "This has a [placeholder]"
        expect(service).to_not be_valid
        expect(service.errors[:service_deliverable]).to include("shouldn't contain placeholder text")
      end
    end

    describe '#no_braces_in_user_facing_attributes' do
      let(:service) { build(:service) }

      it 'prevents braces the title' do
        service.title = "This has a {placeholder}"
        expect(service).to_not be_valid
        expect(service.errors[:title]).to include("shouldn't contain placeholder text")
      end

      it 'prevents braces in the service_request' do
        service.service_request = "This has a {placeholder}"
        expect(service).to_not be_valid
        expect(service.errors[:service_request]).to include("shouldn't contain placeholder text")
      end

      it 'prevents braces in the service_deliverable' do
        service.service_deliverable = "This has a {placeholder}"
        expect(service).to_not be_valid
        expect(service.errors[:service_deliverable]).to include("shouldn't contain placeholder text")
      end
    end
  end

  describe 'state machine' do
    let!(:pha) { create(:pha) }
    let!(:user) { create(:member, :premium, pha: pha) }

    describe 'initial state' do
      context 'with required data fields' do
        let!(:service_template) { create(:service_template) }
        let!(:data_field_template) { create(:data_field_template, service_template: service_template, required_for_service_start: true) }
        let!(:task_template_set) { create(:task_template_set, service_template: service_template) }
        let!(:task_template) { create(:task_template, service_template: service_template, task_template_set: task_template_set) }
        let!(:task_step_template) { create(:task_step_template, task_template: task_template) }

        before do
          task_step_template.add_data_field_template!(data_field_template)
        end

        it 'creates a service in :waiting state' do
          service = user.services.create!(service_template: service_template, actor: pha)
          expect(service).to be_valid
          expect(service).to be_persisted
          expect(service).to be_waiting
        end

        context 'in a conversation with a PHA' do
          let!(:message_task) { create(:message_task, consult: user.master_consult) }

          it 'creates a service in :draft state' do
            service = user.services.create!(service_template: service_template, actor: pha)
            expect(service).to be_valid
            expect(service).to be_persisted
            expect(service).to be_draft
          end
        end
      end

      context 'without required data fields' do
        let!(:service_template) { create(:service_template) }
        let!(:task_template) { create(:task_template, service_template: service_template) }

        it 'creates a service in :open state' do
          service = user.services.create!(service_template: service_template, actor: pha)
          expect(service).to be_valid
          expect(service).to be_persisted
          expect(service).to be_open
        end
      end
    end
  end

  describe '#set_defaults' do
    let(:service_template) { create(:service_template) }
    let(:pha) { create(:pha) }
    let(:member) { create(:member, :premium, pha: pha) }

    before do
      Timecop.freeze
    end

    after do
      Timecop.return
    end

    it 'creates a Service from ServiceTemplate when present' do
      service = described_class.create(service_template: service_template, member: member, actor: pha)
      expect(service).to be_valid
      expect(service.title).to eq(service_template.title)
      expect(service.description).to eq(service_template.description)
      expect(service.service_type).to eq(service_template.service_type)
      expect(service.due_at.to_i).to eq(service_template.calculated_due_at.to_i)
      expect(service.service_update).to eq(service_template.service_update)
      expect(service.user_facing).to eq(service_template.user_facing)
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

  describe '#create_tasks' do
    before do
      Timecop.freeze(Time.parse('2015-07-09 12:00:00 -0700'))
    end

    after do
      Timecop.return
    end

    context 'there are task_templates for the task template sets' do
      context 'the service is a timed service' do
        let!(:service_template) { create :service_template, timed_service: true}
        let!(:affirmative_task_template_set) { create :task_template_set, service_template: service_template }
        let!(:service) { create :service, service_template: service_template }
        let!(:first_task_template_set) { service_template.task_template_sets.first }
        let!(:task_template) { create :task_template, service_template: service_template, task_template_set_id: first_task_template_set.id }
        let!(:another_task_template) { create :task_template, service_template: service_template, task_template_set_id: affirmative_task_template_set.id }

        it 'should create tasks with that task template set starting at the due date' do
          first_task_template_set.update_attributes!(affirmative_child_id: affirmative_task_template_set.id)
          expect{ service.reload.create_next_task_template_set_tasks(nil, 1.day.from_now) }.to change(Task, :count).by(1)
          expect(service.reload.tasks.last.due_at).to eq(task_template.calculated_due_at(1.day.from_now))
        end
      end

      context 'the service is not a timed service' do
        let!(:service_template) { create :service_template, timed_service: false}
        let!(:affirmative_task_template_set) { create :task_template_set, service_template: service_template }
        let!(:first_task_template_set) { service_template.task_template_sets.first }
        let!(:service) { create :service, service_template: service_template }
        let!(:task_template) { create :task_template, service_template: service_template, task_template_set_id: first_task_template_set.id }
        let!(:another_task_template) { create :task_template, service_template: service_template, task_template_set_id: affirmative_task_template_set.id }

        it 'should create tasks with that task_template_set starting now' do
          first_task_template_set.update_attributes!(affirmative_child_id: affirmative_task_template_set.id)
          expect{ service.reload.create_next_task_template_set_tasks(nil, 1.day.from_now) }.to change(Task, :count).by(1)
          expect(service.reload.tasks.last.due_at).to eq(task_template.calculated_due_at(Time.now))
        end
      end
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
        service.update_attributes!(description: 'poop', title: 'shit', actor: service.creator)
        ServiceChange.count.should == 1
        t = ServiceChange.last
        t.service.should == service
        t.event.should == 'update'
        t.data.should == {"description" => [old_description, 'poop'], "title" => [old_title, 'shit']}
      end

      context 'actor is defined' do
        let(:pha) { build_stubbed :pha }

        before do
          service.actor = pha
          service.title = 'Poop'
          service.stub(:previous_changes) { service.changes }
        end

        it 'uses the defined actor' do
          service.service_changes.should_receive(:create!).with hash_including(actor: pha)
          service.send(:track_update)
        end
      end
    end
  end

  describe '#auto_transition!' do
    before do
      Service.any_instance.stub(:reinitialize_state_machine)
    end

    context 'draft?' do
      let!(:pha) { create(:pha) }
      let!(:user) { create(:member, :premium, pha: pha) }
      let!(:service_template) { create(:service_template) }
      let!(:task_template_set) { create(:task_template_set, service_template: service_template) }

      let!(:task_template) { create(:task_template, service_template: service_template, task_template_set: task_template_set) }
      let!(:service) { create(:service, :draft, service_template: service_template, member: user, creator: pha) }

      context 'with message tasks' do
        let!(:message_task) { create(:message_task, consult: user.master_consult) }

        it 'stays in draft' do
          expect(service.reload).to be_draft
          service.auto_transition!
          expect(service.reload).to be_draft
        end
      end

      context 'without message tasks' do
        context 'without all prerequisites' do
          let!(:data_field_template) { create(:data_field_template, service_template: service_template, required_for_service_start: true) }
          let!(:task_step_template) { create(:task_step_template, task_template: task_template) }

          before do
            task_step_template.add_data_field_template!(data_field_template)
          end

          it 'transitions to waiting' do
            expect(service.reload).to be_draft
            service.auto_transition!
            expect(service.reload).to be_waiting
          end

          it 'creates a service blocked task' do
            expect{ service.reload.auto_transition! }.to change(ServiceBlockedTask, :count).by(1)
          end
        end

        context 'with all prerequisites' do
          it 'transitions to open' do
            expect(service.reload).to be_draft
            service.auto_transition!
            expect(service.reload).to be_open
          end
        end
      end
    end
  end
end

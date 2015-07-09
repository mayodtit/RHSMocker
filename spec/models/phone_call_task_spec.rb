require 'spec_helper'

describe PhoneCallTask do
  before do
    @pha_id = Role.find_or_create_by_name!(:pha).id
  end

  describe '#validations' do
    it_validates 'presence of', :phone_call

    describe '#one_message_per_consult' do
      let(:phone_call) { build_stubbed :phone_call }
      let(:task) { build :phone_call_task, phone_call: phone_call }

      context 'and open' do
        context 'and phone call task for phone_call exists' do
          it 'should not be valid if task is different' do
            other_task = build_stubbed :phone_call_task
            PhoneCallTask.stub(:open) do
              o = Object.new
              o.stub(:where).with(phone_call_id: phone_call.id) do
                o = Object.new
                o.stub(:first) { other_task }
                o
              end
              o
            end
            task.should_not be_valid
          end

          it 'should be valid if task is the same' do
            task = build_stubbed :phone_call_task, :claimed, phone_call: phone_call, role: phone_call.to_role
            PhoneCallTask.stub(:open) do
              o = Object.new
              o.stub(:where).with(phone_call_id: phone_call.id) do
                o = Object.new
                o.stub(:first) { task }
                o
              end
              o
            end
            task.should be_valid
          end
        end

        context 'and phone call task for phone_call DNE' do
          it 'should be valid' do
            PhoneCallTask.stub(:open) do
              o = Object.new
              o.stub(:where).with(phone_call_id: phone_call.id) do
                o = Object.new
                o.stub(:first) { nil }
                o
              end
              o
            end
            task.should be_valid
          end
        end
      end

      context 'and not open' do
        before do
          task.stub(:open?) { false }
        end

        it 'should be valid' do
          task.should be_valid
        end
      end
    end
  end

  describe '#set_role' do
    let(:task) { build :phone_call_task }

    context 'role_id is nil' do
      before do
        task.role_id = nil
      end

      context 'phone_call exists' do
        before do
          task.phone_call.stub(:to_role_id) { 5 }
        end

        it 'sets it to the phone calls role' do
          task.set_role
          task.role_id.should == 5
        end
      end
    end

    context 'role_id is present' do

      before do
        task.stub(:role_id) { 2 }
      end

      it 'does nothing' do
        task.should_not_receive(:role_id=)
        task.set_role
      end
    end
  end

  describe '#create_if_only_opened_for_phone_call!' do
    let(:phone_call) { build_stubbed(:phone_call) }

    context 'role not on call' do
      before do
        phone_call.to_role.stub(:on_call?) { false }
      end

      it 'does nothing' do
        PhoneCallTask.should_not_receive(:create!)
        PhoneCallTask.create_if_only_opened_for_phone_call!(phone_call)
      end
    end

    context 'role on call' do
      before do
        phone_call.to_role.stub(:on_call?) { true }
      end

      context 'other open phone call task exists for phone_call' do
        before do
          PhoneCallTask.stub(:open) do
            o = Object.new
            o.stub(:where).with(phone_call_id: phone_call.id) do
              o = Object.new
              o.stub(:count) { 1 }
              o
            end
            o
          end
        end

        it 'does nothing' do
          PhoneCallTask.should_not_receive(:create!)
          PhoneCallTask.create_if_only_opened_for_phone_call!(phone_call)
        end
      end

      context 'other open phone call task doesn\'t exist for phone_call' do
        before do
          PhoneCallTask.stub(:open) do
            o = Object.new
            o.stub(:where).with(phone_call_id: phone_call.id) do
              o = Object.new
              o.stub(:count) { 0 }
              o
            end
            o
          end
        end

        it 'creates a task with the phone_call' do
          PhoneCallTask.should_receive(:create!).with(title: 'Inbound Phone Call', phone_call: phone_call, creator: Member.robot, due_at: phone_call.created_at)
          PhoneCallTask.create_if_only_opened_for_phone_call!(phone_call)
        end
      end

    end
  end

  describe 'states' do
    let(:pha) { build_stubbed(:pha) }

    describe '#claim' do
      let(:task) { build :phone_call_task }

      it 'claims the phone call' do
        task.owner = pha
        task.assignor = pha
        task.phone_call.stub(:claimed?) { false }
        task.phone_call.should_receive(:update_attributes!).with(state_event: :claim, claimer: pha)
        task.claim!
      end
    end

    describe '#unclaim' do
      let(:task) { build :phone_call_task, :claimed }

      it 'unclaims a call' do
        task.phone_call.should_receive(:update_attributes!).with(state_event: :unclaim)
        task.unclaim!
      end
    end

    describe '#complete' do
      let(:task) { build :phone_call_task, :claimed }

      it 'claims the phone call' do
        task.phone_call.stub(:in_progress?) { true }
        task.owner = pha
        task.phone_call.should_receive(:update_attributes!).with(state_event: :end, ender: pha)
        task.complete!
      end
    end

    describe '#abandon' do
      let(:task) { build :phone_call_task, :claimed }

      it 'claims the phone call' do
        task.phone_call.stub(:in_progress?) { true }
        task.abandoner = pha
        task.reason = 'pooed'
        task.phone_call.should_receive(:update_attributes!).with(state_event: :end, ender: pha)
        task.abandon!
      end
    end
  end

  describe '#set_priority' do
    let(:task) { build :phone_call_task }

    it 'sets it to zero' do
      task.set_priority
      task.priority.should == PhoneCallTask::PRIORITY
    end
  end

  describe '#notify' do
    let(:task) { build :phone_call_task }
    let(:pha) do
      pha = create(:pha)
      pha.text_phone_number = '6503214000'
      pha
    end

    context 'task is not for pha' do
      before do
        task.stub(:for_pha?) { false }
        task.stub(:owner_id_changed?) { true }
      end

      it 'does nothing' do
        UserMailer.should_not_receive :delay
        task.notify
      end
    end

    context 'task is not for pha' do
      before do
        task.stub(:for_pha?) { true }
      end
      context 'owner_id changed' do
        before do
          task.stub(:owner_id_changed?) { true }
        end

        context 'unassigned' do
          let(:phas) do
            pha1 = create(:pha)
            pha1.text_phone_number = '6503214111'
            pha2 = create(:pha)
            pha2.text_phone_number = '6503214222'
            pha3 = create(:pha)
            pha3.text_phone_number = '6503214333'

            [pha1, pha2, pha3]
          end

          before do
            task.stub(:unassigned?) { true }
            Role.stub_chain(:pha, :users) do
              o = Object.new
              o.stub(:where).with(on_call: true) { phas }
              o
            end
          end

          it 'texts the phas on duty' do
            TwilioModule.should_receive(:message).with '6503214111', 'ALERT: Inbound phone call needs triage'
            TwilioModule.should_receive(:message).with '6503214222', 'ALERT: Inbound phone call needs triage'
            TwilioModule.should_receive(:message).with '6503214333', 'ALERT: Inbound phone call needs triage'
            task.notify
          end
        end

        context 'assigned to owner' do
          before do
            task.stub(:unassigned?) { false }
            task.stub(:owner) { pha }
          end

          context 'assignor is owner' do
            before do
              task.stub(:assignor_id) { 1 }
              task.stub(:owner_id) { 1 }
            end

            it 'does nothing' do
              TwilioModule.should_not_receive :message
              task.notify
            end
          end

          context 'assignor is not owner' do
            before do
              task.stub(:assignor_id) { 1 }
              task.stub(:owner_id) { 2 }
            end

            it 'texts the owner' do
              TwilioModule.should_receive(:message).with '6503214000', 'ALERT: Inbound phone call assigned to you'
              task.notify
            end
          end
        end
      end

      context 'owner_id has not changed' do
        before do
          task.stub(:owner_id_changed?) { false }
        end

        it 'does nothing' do
          TwilioModule.should_not_receive :message
          task.notify
        end
      end
    end
  end

  describe '#set_member' do
    let(:phone_call) { build_stubbed :phone_call }
    let(:phone_call_task) { build_stubbed :phone_call_task, phone_call: phone_call }

    it 'sets the member to the consult initiator' do
      phone_call_task.member = nil
      phone_call_task.set_member
      phone_call_task.member.should == phone_call.user
    end
  end
end

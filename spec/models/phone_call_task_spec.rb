require 'spec_helper'

describe PhoneCallTask do
  let!(:pha_role) { Role.find_by_name(:pha) || create(:role, name: :pha) }

  it_has_a 'valid factory'

  describe '#validations' do
    it_validates 'presence of', :phone_call

    describe '#one_open_per_phone_call' do
      let!(:consult) { create(:consult) }
      let!(:phone_call) { create(:phone_call, consult: consult) }

      context 'with an already open task' do
        let!(:other_task) { create(:phone_call_task, phone_call: phone_call, role: pha_role) }

        it 'adds an error if there are any other open phone call tasks' do
          task = build(:phone_call_task, phone_call: phone_call, role: pha_role)
          expect(task).to_not be_valid
          expect(task.errors[:phone_call_id]).to include("open PhoneCallTask already exists for #{phone_call.id}")
        end
      end

      it 'does not add an error when the message task is the only task' do
        expect(described_class.where(phone_call_id: phone_call.id)).to be_empty
        task = create(:phone_call_task, phone_call: phone_call, role: pha_role)
        expect(task).to be_valid
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

    describe '#unstart' do
      let(:task) { build :phone_call_task, :started }

      it 'unclaims a call' do
        task.phone_call.should_receive(:update_attributes!).with(state_event: :unclaim)
        task.unstart!
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
end

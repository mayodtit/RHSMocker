require 'spec_helper'

describe PhoneCallTask do
  before do
    @pha_id = Role.find_or_create_by_name!(:pha).id
  end

  describe '#validations' do
    it_validates 'presence of', :phone_call_id
    it_validates 'foreign key of', :phone_call

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
        task.reason_abandoned = 'pooed'
        task.phone_call.should_receive(:update_attributes!).with(state_event: :end, ender: pha)
        task.abandon!
      end
    end
  end
end

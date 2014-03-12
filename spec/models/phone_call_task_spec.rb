require 'spec_helper'

describe PhoneCallTask do
  describe '#set_role' do
    let(:task) { build :phone_call_task }

    context 'role_id is nil' do
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

  describe '#member' do
    let(:task) { build :phone_call_task }
    let(:member) { build :member }

    context 'phone call has user' do
      before do
        task.phone_call.stub(:user) { member }
      end

      it 'returns the phone calls member' do
        task.member.should == member
      end
    end

    context 'consult' do
      before do
        task.phone_call.stub(:user) { nil }
        task.consult.stub(:initiator) { member }
      end

      it 'returns the phone calls member' do
        task.member.should == member
      end
    end

    context 'neither user nor consult' do
      before do
        task.phone_call.stub(:user) { nil }
        task.stub(:consult) { nil }
      end

      it 'returns nil' do
        task.member.should be_nil
      end
    end
  end

  describe 'states' do
    let(:pha) { build_stubbed(:pha) }

    describe '#claim' do
      let(:task) { build :phone_call_task }

      it 'claims the phone call' do
        task.owner = pha
        task.phone_call.stub(:claimed?) { false }
        task.phone_call.should_receive(:update_attributes!).with(state_event: :claim, claimer: pha)
        task.claim!
      end
    end

    describe '#unassign' do
      let(:task) { build :phone_call_task, :assigned }

      it 'unclaims a call' do
        task.phone_call.should_receive(:update_attributes!).with(state_event: :unclaim)
        task.unassign!
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

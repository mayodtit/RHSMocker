require 'spec_helper'

describe ScheduledPhoneCall do
  it_has_a 'valid factory'
  it_validates 'presence of', :scheduled_at

  describe 'states' do
    let(:pha_lead) { build_stubbed(:pha_lead) }
    let(:pha) { build_stubbed(:pha) }
    let(:member) { build_stubbed(:member) }
    let(:scheduled_phone_call) { build(:scheduled_phone_call) }
    let(:other_scheduled_phone_call) { build(:scheduled_phone_call) }

    before do
      Timecop.freeze()
    end

    after do
      Timecop.return
    end

    it 'has an initial state of unassigned' do
      scheduled_phone_call.should be_unassigned
    end

    describe '#assign' do
      before do
        scheduled_phone_call.assign! pha_lead, pha
      end

      it 'changes the state to assigned' do
        scheduled_phone_call.should be_assigned
      end

      it 'sets the assigned time' do
        scheduled_phone_call.assigned_at.should == Time.now
      end

      it 'sets the assignor as the first argument' do
        scheduled_phone_call.assignor.should == pha_lead
      end

      it 'sets the owner as the second argument' do
        scheduled_phone_call.owner.should == pha
      end

      it 'sets both assign and owner if there is only one argument' do
        other_scheduled_phone_call.assign! pha_lead
        other_scheduled_phone_call.assignor.should == pha_lead
        other_scheduled_phone_call.owner.should == pha_lead
      end
    end

    describe '#book' do
      let(:consult) { build :consult }
      let(:message) { build :message }

      before do
        scheduled_phone_call.state = 'assigned'
        other_scheduled_phone_call.state = 'assigned'
        scheduled_phone_call.message = message
        scheduled_phone_call.book! pha, member
      end

      it 'changes the state to booked' do
        scheduled_phone_call.should be_booked
      end

      it 'sets the booked time' do
        scheduled_phone_call.booked_at.should == Time.now
      end

      it 'sets the booker as the first argument' do
        scheduled_phone_call.booker.should == pha
      end

      it 'sets the member as the second argument' do
        scheduled_phone_call.user.should == member
      end

      it 'sets both assign and owner if there is only one argument' do
        other_scheduled_phone_call.book! member
        other_scheduled_phone_call.booker.should == member
        other_scheduled_phone_call.user.should == member
      end

      it 'creates a welcome call consult if it doesn\'t exist' do
        Consult.should_receive(:create!).with(
          title: ScheduledPhoneCall::DEFAULT_CONSULT_TITLE,
          initiator: member,
          subject: member,
          add_user: member
        ) { consult }

        Message.should_receive(:create!).with(
          user: pha_lead,
          consult: consult,
          scheduled_phone_call: other_scheduled_phone_call
        ) { message }

        other_scheduled_phone_call.owner = pha_lead
        other_scheduled_phone_call.state = 'assigned'
        other_scheduled_phone_call.book! pha, member
      end
    end

    describe '#start' do
      before do
        scheduled_phone_call.state = 'booked'
        other_scheduled_phone_call.state = 'booked'
        scheduled_phone_call.start! pha
      end

      it_behaves_like 'cannot transition from', :start!, :start, [:ended, :canceled, :started]

      it 'changes the state to started' do
        scheduled_phone_call.should be_started
      end

      it 'sets the started time' do
        scheduled_phone_call.started_at.should == Time.now
      end

      it 'sets the starter as the first argument' do
        scheduled_phone_call.starter.should == pha
      end
    end

    describe '#cancel' do
      before do
        scheduled_phone_call.state = 'started'
        other_scheduled_phone_call.state = 'started'
        scheduled_phone_call.cancel! pha
      end

      it_behaves_like 'cannot transition from', :cancel!, :canceled, [:ended, :canceled]

      it 'changes the state to canceled' do
        scheduled_phone_call.should be_canceled
      end

      it 'sets the canceled time' do
        scheduled_phone_call.canceled_at.should == Time.now
      end

      it 'sets the disabled time' do
        scheduled_phone_call.disabled_at.should == Time.now
      end

      it 'sets the canceler as the first argument' do
        scheduled_phone_call.canceler.should == pha
      end
    end

    describe '#ended' do
      before do
        scheduled_phone_call.state = 'started'
        other_scheduled_phone_call.state = 'started'
        scheduled_phone_call.end! pha
      end

      it_behaves_like 'cannot transition from', :end!, :ended, [:ended, :canceled]

      it 'changes the state to ended' do
        scheduled_phone_call.should be_ended
      end

      it 'sets the ended time' do
        scheduled_phone_call.ended_at.should == Time.now
      end

      it 'sets the ender as the first argument' do
        scheduled_phone_call.ender.should == pha
      end
    end
  end
end

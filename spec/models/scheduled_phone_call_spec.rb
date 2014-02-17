require 'spec_helper'

describe ScheduledPhoneCall do
  let(:scheduled_phone_call) { build(:scheduled_phone_call) }

  it_has_a 'valid factory'
  it_validates 'presence of', :scheduled_at

  describe '#notify_owner_of_assigned_call' do
    it 'notifies the owner they were assigned a time to receive a scheduled call' do
      UserMailer.should_receive(:scheduled_phone_call_cp_assigned_email).with(scheduled_phone_call) {
        o = Object.new
        o.should_receive(:deliver)
        o
      }
      scheduled_phone_call.notify_owner_of_assigned_call
    end
  end

  describe '#notify_user_confirming_call' do
    it 'notifies the user confirming their scheduled call time via email' do
      RHSMailer.should_receive(:scheduled_phone_call_member_confirmation_email).with(scheduled_phone_call.id) {
        o = Object.new
        o.should_receive(:deliver)
        o
      }
      scheduled_phone_call.notify_user_confirming_call
    end
  end

  describe '#notify_owner_confirming_call' do
    it 'notifies the owner confirming their scheduled call time via email' do
      UserMailer.should_receive(:scheduled_phone_call_cp_confirmation_email).with(scheduled_phone_call) {
        o = Object.new
        o.should_receive(:deliver)
        o
      }
      scheduled_phone_call.notify_owner_confirming_call
    end
  end

  describe 'after create' do
    it 'notifies the owner if is assigned' do
      spc = ScheduledPhoneCall.new(scheduled_at: 3.days.from_now, state: 'assigned', assigned_at: Time.now, assignor: create(:pha_lead), owner: create(:pha))
      spc.should_receive :notify_owner_of_assigned_call
      spc.save!
    end

    it 'doesn\'t notify the owner if it is not assigned' do
      spc = build(:scheduled_phone_call)
      spc.should_not_receive :notify_owner_of_assigned_call
      spc.save!
    end
  end

  describe 'states' do
    let(:pha_lead) { build_stubbed(:pha_lead) }
    let(:pha) { build_stubbed(:pha) }
    let(:other_pha) { build_stubbed(:pha) }
    let(:member) { build_stubbed(:member) }
    let(:other_scheduled_phone_call) { build(:scheduled_phone_call) }
    let(:consult) { build :consult }
    let(:message) { build :message, consult: consult }

    before do
      ScheduledPhoneCall.any_instance.stub(:notify_user_confirming_call).and_return(true)
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
        scheduled_phone_call.update_attributes state_event: 'assign', assignor: pha_lead, owner: pha
      end

      it_behaves_like 'cannot transition from', :assign!, [:ended, :canceled, :started]

      it 'changes the state to assigned' do
        scheduled_phone_call.should be_assigned
      end

      it 'sets the assigned time' do
        scheduled_phone_call.assigned_at.should == Time.now
      end

      it 'notifies the owner that they were assigned' do
        other_scheduled_phone_call.save!
        other_scheduled_phone_call.should_receive :notify_owner_of_assigned_call
        other_scheduled_phone_call.update_attributes state_event: 'assign', assignor: pha_lead, owner: pha
      end

      it 'can transition to assigned again' do
        scheduled_phone_call.update_attributes state_event: 'assign', assignor: pha_lead, owner: other_pha
        scheduled_phone_call.should be_assigned
      end
    end

    describe '#book' do

      before do
        scheduled_phone_call.state = 'assigned'
        other_scheduled_phone_call.state = 'assigned'
        scheduled_phone_call.owner = pha
        other_scheduled_phone_call.owner = pha

        scheduled_phone_call.update_attributes state_event: 'book', booker: pha, user: member, message: message
      end

      it_behaves_like 'cannot transition from', :book!, [:ended, :canceled, :started, :unassigned]

      it 'changes the state to booked' do
        scheduled_phone_call.should be_booked
      end

      it 'sets the booked time' do
        scheduled_phone_call.booked_at.should == Time.now
      end

      it 'notifies the owner confirming that they booked the call' do
        other_scheduled_phone_call.should_receive :notify_user_confirming_call
        other_scheduled_phone_call.update_attributes state_event: 'book', booker: pha, user: member, message: message
      end

      it 'notifies the user confirming that their call was booked' do
        other_scheduled_phone_call.should_receive :notify_owner_confirming_call
        other_scheduled_phone_call.update_attributes state_event: 'book', booker: pha, user: member, message: message
      end
    end

    describe '#start' do
      before do
        scheduled_phone_call.state = 'booked'
        scheduled_phone_call.message = message
        scheduled_phone_call.owner = pha
        scheduled_phone_call.user = member

        scheduled_phone_call.update_attributes state_event: 'start', starter: pha
      end

      it_behaves_like 'cannot transition from', :start!, [:ended, :canceled, :started]

      it 'changes the state to started' do
        scheduled_phone_call.should be_started
      end

      it 'sets the started time' do
        scheduled_phone_call.started_at.should == Time.now
      end
    end

    describe '#cancel' do
      before do
        scheduled_phone_call.state = 'started'
        scheduled_phone_call.message = message
        scheduled_phone_call.owner = pha
        scheduled_phone_call.user = member
        scheduled_phone_call.update_attributes state_event: 'cancel', canceler: member
      end

      it_behaves_like 'cannot transition from', :cancel!, [:ended, :canceled]

      it 'changes the state to canceled' do
        scheduled_phone_call.should be_canceled
      end

      it 'sets the canceled time' do
        scheduled_phone_call.canceled_at.should == Time.now
      end

      it 'sets the disabled time' do
        scheduled_phone_call.disabled_at.should == Time.now
      end
    end

    describe '#ended' do
      before do
        scheduled_phone_call.state = 'started'
        scheduled_phone_call.message = message
        scheduled_phone_call.owner = pha
        scheduled_phone_call.user = member
        scheduled_phone_call.update_attributes state_event: 'end', ender: pha
      end

      it_behaves_like 'cannot transition from', :end!, [:ended, :canceled]

      it 'changes the state to ended' do
        scheduled_phone_call.should be_ended
      end

      it 'sets the ended time' do
        scheduled_phone_call.ended_at.should == Time.now
      end
    end
  end
end

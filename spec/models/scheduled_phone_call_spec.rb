require 'spec_helper'

describe ScheduledPhoneCall do
  let(:scheduled_phone_call) { build(:scheduled_phone_call) }
  let(:delayed_user_mailer) { double('delayed user mailer', scheduled_phone_call_cp_assigned_email: true,
                                                            scheduled_phone_call_cp_confirmation_email: true,
                                                            notify_phas_of_new_task: true,
                                                            notify_pha_of_new_member: true) }
  let(:delayed_rhs_mailer) { double('delayed rhs mailer', scheduled_phone_call_member_confirmation_email: true,
                                                          welcome_to_better_email: true) }

  before do
    UserMailer.stub(delay: delayed_user_mailer)
    RHSMailer.stub(delay: delayed_rhs_mailer)
  end

  it_has_a 'valid factory'
  it_has_a 'valid factory', :assigned
  it_has_a 'valid factory', :booked
  it_validates 'presence of', :scheduled_at
  it_validates 'foreign key of', :user
  it_validates 'foreign key of', :reminder_scheduled_message

  describe '#notify_owner_of_assigned_call' do
    it 'notifies the owner they were assigned a time to receive a scheduled call' do
      delayed_user_mailer.should_receive(:scheduled_phone_call_cp_assigned_email)
                         .with(scheduled_phone_call)
      scheduled_phone_call.notify_owner_of_assigned_call
    end
  end

  describe '#notify_user_confirming_call' do
    it 'notifies the user confirming their scheduled call time via email' do
      Mails::ScheduledPhoneCallMemberConfirmationJob.should_receive(:create)
                                                    .with(scheduled_phone_call.id)
      scheduled_phone_call.notify_user_confirming_call
    end
  end

  describe '#notify_owner_confirming_call' do
    it 'notifies the owner confirming their scheduled call time via email' do
      delayed_user_mailer.should_receive(:scheduled_phone_call_cp_confirmation_email)
                         .with(scheduled_phone_call)
      scheduled_phone_call.notify_owner_confirming_call
    end
  end

  describe '#assign_pha_to_user!' do
    let(:scheduled_phone_call) { create(:scheduled_phone_call, :booked) }

    it "assigns the owner as the user's PHA" do
      expect(scheduled_phone_call.user.pha).to be_nil
      scheduled_phone_call.assign_pha_to_user!
      expect(scheduled_phone_call.reload.user.pha).to eq(scheduled_phone_call.owner)
    end

    it 'does not change the PHA if one is already assigned' do
      pha = create(:pha)
      expect(scheduled_phone_call.user.update_attributes(pha: pha)).to be_true
      scheduled_phone_call.assign_pha_to_user!
      expect(scheduled_phone_call.reload.user.pha).to eq(pha)
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

  describe 'set_user_phone_if_missing' do
    let(:scheduled_phone_call) { create(:scheduled_phone_call, :booked) }

    context 'no user' do
      before do
        scheduled_phone_call.user = nil
      end

      it 'does nothing' do
        scheduled_phone_call.set_user_phone_if_missing
      end
    end

    context 'user exists' do
      context 'user has a phone number already' do
        before do
          scheduled_phone_call.user.stub(:phone) { '4083913578' }
        end

        it 'does not set the user phone' do
          scheduled_phone_call.set_user_phone_if_missing
          scheduled_phone_call.user.phone.should_not == scheduled_phone_call.callback_phone_number
        end
      end

      context 'user does not have a phone number' do
        before do
          scheduled_phone_call.user.phone = nil
        end

        it 'does not set the user phone' do
          scheduled_phone_call.user.should_receive(:save!)
          scheduled_phone_call.set_user_phone_if_missing
          scheduled_phone_call.user.phone.should == scheduled_phone_call.callback_phone_number
        end
      end
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
      let(:member) { create(:member) }
      let(:pha) { create(:pha) }
      let(:scheduled_phone_call) { build(:scheduled_phone_call, :assigned, owner: pha) }

      before do
        member.pha = pha
      end

      def book
        scheduled_phone_call.update_attributes(state_event: 'book',
                                               booker: pha,
                                               user: member,
                                               message: message)
      end

      it_behaves_like 'cannot transition from', :book!, [:ended, :canceled, :started, :unassigned]

      it 'changes the state to booked' do
        expect(book).to be_true
        expect(scheduled_phone_call).to be_booked
      end

      it 'sets the booked time' do
        expect(book).to be_true
        expect(scheduled_phone_call.booked_at).to eq(Time.now)
      end

      it 'notifies the owner confirming that they booked the call' do
        scheduled_phone_call.should_receive :notify_user_confirming_call
        expect(book).to be_true
      end

      it 'notifies the user confirming that their call was booked via email' do
        scheduled_phone_call.should_receive :notify_owner_confirming_call
        expect(book).to be_true
      end

      it 'notifies the user confirming that their call was booked via message' do
        Metadata.stub(:new_onboarding_flow?) { true }
        member.stub(:master_consult) { consult }
        mt = build :message_template
        MessageTemplate.stub(:find_by_name).with('Confirm Welcome Call') { mt }
        mt.should_receive(:create_message).with(pha, consult, true, true)
        expect(book).to be_true
      end

      it 'assigns the owner as the user\'s PHA' do
        member.pha = nil
        expect(member.pha).to be_nil
        expect(book).to be_true
        expect(member.reload.pha).to eq(pha)
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

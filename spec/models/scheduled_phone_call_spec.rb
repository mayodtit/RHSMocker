require 'spec_helper'

describe ScheduledPhoneCall do
  let(:scheduled_phone_call) { build(:scheduled_phone_call) }
  let(:delayed_user_mailer) { double('delayed user mailer', scheduled_phone_call_cp_assigned_email: true,
                                                            scheduled_phone_call_cp_confirmation_email: true,
                                                            notify_of_assigned_task: true,
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
    let(:time) do
      prev_global_time_zone = Time.zone
      Time.zone = ActiveSupport::TimeZone.new('America/Los_Angeles')
      time = Time.roll_forward(3.days.from_now.in_time_zone(Time.zone)).on_call_start_oclock + 1.hour
      Time.zone = prev_global_time_zone
      time.utc
    end

    it 'notifies the owner if is assigned' do
      spc = ScheduledPhoneCall.new(scheduled_at: time, state: 'assigned', assigned_at: Time.now, assignor: create(:pha_lead), owner: create(:pha))
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

  describe '#create_reminder' do
    let!(:message_template) { create(:message_template) }

    before do
      MessageTemplate.stub(find_by_name: message_template)
    end

    context 'scheduled_at on Tu/W/Th/F' do
      let!(:scheduled_at) { Time.new(2014, 7, 25, 12, 0, 0, '-07:00') }
      let!(:user) { create(:member, :premium) }
      let!(:scheduled_phone_call) do
        create(:scheduled_phone_call, :booked, user: user,
                                               scheduled_at: scheduled_at)
      end

      before do
        ScheduledPhoneCall.destroy_all
      end

      context 'the same day' do
        it 'schedules the message for the scheduled day at the start of on call hours pacific' do
          Timecop.freeze(Time.new(2014, 7, 25, 8, 0, 0, '-07:00'))
          expect{ scheduled_phone_call.reload.book! }.to change(ScheduledMessage, :count).by(1)
          expect(user.inbound_scheduled_communications.count).to eq(1)
          scheduled_message = scheduled_phone_call.reload.reminder_scheduled_message
          expect(scheduled_message.state?(:scheduled)).to be_true
          expect(scheduled_message.recipient).to eq(user)
          expect(scheduled_message.text).to eq(message_template.text)
          expect(scheduled_message.publish_at).to eq(Time.new(2014, 7, 25, ON_CALL_START_HOUR, 0, 0, '-07:00'))
          expect(scheduled_message.variables['day']).to eq('today')
          Timecop.return
        end
      end

      context 'the day before' do
        it 'schedules the message for the scheduled day at the start of on call hours pacific' do
          Timecop.freeze(Time.new(2014, 7, 24, 0, 0, 0, '-07:00'))
          expect{ scheduled_phone_call.reload.book! }.to change(ScheduledMessage, :count).by(1)
          expect(user.inbound_scheduled_communications.count).to eq(1)
          scheduled_message = scheduled_phone_call.reload.reminder_scheduled_message
          expect(scheduled_message.state?(:scheduled)).to be_true
          expect(scheduled_message.recipient).to eq(user)
          expect(scheduled_message.text).to eq(message_template.text)
          expect(scheduled_message.publish_at).to eq(Time.new(2014, 7, 25, ON_CALL_START_HOUR, 0, 0, '-07:00'))
          expect(scheduled_message.variables['day']).to eq('today')
          Timecop.return
        end
      end

      context 'before the day before' do
        it 'schedules the message for the day before at at the start of on call hours pacific' do
          Timecop.freeze(Time.new(2014, 7, 23, 23, 59, 59, '-07:00'))
          expect{ scheduled_phone_call.reload.book! }.to change(ScheduledMessage, :count).by(1)
          expect(user.inbound_scheduled_communications.count).to eq(1)
          scheduled_message = scheduled_phone_call.reload.reminder_scheduled_message
          expect(scheduled_message.state?(:scheduled)).to be_true
          expect(scheduled_message.recipient).to eq(user)
          expect(scheduled_message.text).to eq(message_template.text)
          expect(scheduled_message.publish_at).to eq(Time.new(2014, 7, 24, ON_CALL_START_HOUR, 0, 0, '-07:00'))
          expect(scheduled_message.variables['day']).to eq('Friday')
          Timecop.return
        end
      end

      context 'less than 2 hours to the call' do
        it 'does not schedule a message' do
          Timecop.freeze(Time.new(2014, 7, 25, 10, 0, 1, '-07:00'))
          expect{ scheduled_phone_call.reload.book! }.to change(ScheduledMessage, :count).by(0)
          expect(user.inbound_scheduled_communications.count).to eq(0)
          Timecop.return
        end
      end
    end

    context 'scheduled_at on M' do
      let!(:scheduled_at) { Time.new(2014, 7, 28, 12, 0, 0, '-07:00') }
      let!(:user) { create(:member, :premium) }
      let!(:scheduled_phone_call) do
        create(:scheduled_phone_call, :booked, user: user,
                                               scheduled_at: scheduled_at)
      end

      context 'the same day' do
        it 'schedules the message for the scheduled day at the start of on call hours pacific' do
          Timecop.freeze(Time.new(2014, 7, 28, 8, 0, 0, '-07:00'))
          expect{ scheduled_phone_call.reload.book! }.to change(ScheduledMessage, :count).by(1)
          expect(user.inbound_scheduled_communications.count).to eq(1)
          scheduled_message = scheduled_phone_call.reload.reminder_scheduled_message
          expect(scheduled_message.state?(:scheduled)).to be_true
          expect(scheduled_message.recipient).to eq(user)
          expect(scheduled_message.text).to eq(message_template.text)
          expect(scheduled_message.publish_at).to eq(Time.new(2014, 7, 28, ON_CALL_START_HOUR, 0, 0, '-07:00'))
          expect(scheduled_message.variables['day']).to eq('today')
          Timecop.return
        end
      end

      context 'on S/Su' do
        it 'schedules the message for the scheduled day at the start of on call hours pacific' do
          Timecop.freeze(Time.new(2014, 7, 26, 8, 0, 0, '-07:00'))
          expect{ scheduled_phone_call.reload.book! }.to change(ScheduledMessage, :count).by(1)
          expect(user.inbound_scheduled_communications.count).to eq(1)
          scheduled_message = scheduled_phone_call.reload.reminder_scheduled_message
          expect(scheduled_message.state?(:scheduled)).to be_true
          expect(scheduled_message.recipient).to eq(user)
          expect(scheduled_message.text).to eq(message_template.text)
          expect(scheduled_message.publish_at).to eq(Time.new(2014, 7, 28, ON_CALL_START_HOUR, 0, 0, '-07:00'))
          expect(scheduled_message.variables['day']).to eq('today')
          Timecop.return
        end
      end

      context 'on F' do
        it 'schedules the message for the scheduled day at the start of on call hours pacific' do
          Timecop.freeze(Time.new(2014, 7, 25, 8, 0, 0, '-07:00'))
          expect{ scheduled_phone_call.reload.book! }.to change(ScheduledMessage, :count).by(1)
          expect(user.inbound_scheduled_communications.count).to eq(1)
          scheduled_message = scheduled_phone_call.reload.reminder_scheduled_message
          expect(scheduled_message.state?(:scheduled)).to be_true
          expect(scheduled_message.recipient).to eq(user)
          expect(scheduled_message.text).to eq(message_template.text)
          expect(scheduled_message.publish_at).to eq(Time.new(2014, 7, 28, ON_CALL_START_HOUR, 0, 0, '-07:00'))
          expect(scheduled_message.variables['day']).to eq('today')
          Timecop.return
        end
      end

      context 'before F' do
        it 'schedules the message for the day before the weekend at the start of on call hours pacific' do
          Timecop.freeze(Time.new(2014, 7, 24, 8, 0, 0, '-07:00'))
          expect{ scheduled_phone_call.reload.book! }.to change(ScheduledMessage, :count).by(1)
          expect(user.inbound_scheduled_communications.count).to eq(1)
          scheduled_message = scheduled_phone_call.reload.reminder_scheduled_message
          expect(scheduled_message.state?(:scheduled)).to be_true
          expect(scheduled_message.recipient).to eq(user)
          expect(scheduled_message.text).to eq(message_template.text)
          expect(scheduled_message.publish_at).to eq(Time.new(2014, 7, 25, ON_CALL_START_HOUR, 0, 0, '-07:00'))
          expect(scheduled_message.variables['day']).to eq('Monday')
          Timecop.return
        end
      end

      context 'less than 2 hours to the call' do
        it 'does not schedule a message' do
          Timecop.freeze(Time.new(2014, 7, 28, 10, 0, 1, '-07:00'))
          expect{ scheduled_phone_call.reload.book! }.to change(ScheduledMessage, :count).by(0)
          expect(user.inbound_scheduled_communications.count).to eq(0)
          Timecop.return
        end
      end
    end
  end

  describe 'states' do
    let(:time) do
      prev_global_time_zone = Time.zone
      Time.zone = ActiveSupport::TimeZone.new('America/Los_Angeles')
      time = Time.roll_forward(4.days.from_now.in_time_zone(Time.zone)).on_call_start_oclock + 1.hour
      Time.zone = prev_global_time_zone
      time.utc
    end

    let(:pha_lead) { build_stubbed(:pha_lead) }
    let(:pha) { build_stubbed(:pha) }
    let(:other_pha) { build_stubbed(:pha) }
    let(:member) { build_stubbed(:member) }
    let(:other_scheduled_phone_call) { build(:scheduled_phone_call, scheduled_at: time) }
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

    shared_examples 'won\'t double book pha' do |state|
      context 'new lets' do
        let(:time) do
          prev_global_time_zone = Time.zone
          Time.zone = ActiveSupport::TimeZone.new('America/Los_Angeles')
          time = Time.roll_forward(5.days.from_now.in_time_zone(Time.zone)).on_call_start_oclock + 1.hour
          Time.zone = prev_global_time_zone
          time.utc
        end
        let!(:pha) { create :pha }
        let!(:member) { create :member, pha: pha }
        let(:scheduled_phone_call) { build :scheduled_phone_call, state, owner: pha, user: member, scheduled_at: time }

        before do
          # This clears the context above this
          ScheduledPhoneCall.destroy_all
          scheduled_phone_call.message = nil
        end

        it 'fails validations if scheduled phone calls are not assigned' do
          create :scheduled_phone_call, :assigned, scheduled_at: scheduled_phone_call.scheduled_at, owner: pha
          scheduled_phone_call.should_not be_valid
        end

        it 'ignores scheduled phone calls that are not assigned' do
          create :scheduled_phone_call, scheduled_at: scheduled_phone_call.scheduled_at
          scheduled_phone_call.should be_valid
        end
      end
    end

    describe '#assign' do
      before do
        scheduled_phone_call.update_attributes state_event: 'assign', assignor: pha_lead, owner: pha
      end

      it_behaves_like 'cannot transition from', :assign!, [:ended, :canceled]

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

      it_behaves_like 'won\'t double book pha', :assigned
    end

    describe '#book' do
      let!(:pha) { create(:pha) }
      let!(:member) { create(:member, :premium, pha: pha) }
      let!(:scheduled_phone_call) { build(:scheduled_phone_call, :assigned, owner: pha) }
      let!(:confirm_template) do
        create(:message_template, name: 'Confirm Welcome Call',
                                  text: 'Confirm Welcome Call')
      end
      let!(:reminder_template) do
        create(:message_template, name: 'Welcome Call Reminder',
                                  text: 'Welcome Call Reminder')
      end

      def book
        scheduled_phone_call.update_attributes(state_event: 'book',
                                               booker: pha,
                                               user: member)
      end

      it_behaves_like 'cannot transition from', :book!, [:ended, :canceled, :unassigned]

      it 'changes the state to booked' do
        expect(book).to be_true
        expect(scheduled_phone_call).to be_booked
      end

      it 'sets the booked time' do
        expect(book).to be_true
        expect(scheduled_phone_call.booked_at).to eq(Time.now)
      end

      it 'creates or updates a task' do
        scheduled_phone_call.should_receive :create_task
        expect(book).to be_true
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
        expect{ expect(book).to be_true }.to change(Message, :count).by(1)
      end

      it 'assigns the owner as the user\'s PHA' do
        member.pha = nil
        expect(member.pha).to be_nil
        expect(book).to be_true
        expect(member.reload.pha).to eq(pha)
      end

      it_behaves_like 'won\'t double book pha', :booked
    end

    describe '#cancel' do
      let!(:member_with_phone) { create(:member, phone: 1234567890)}
      let!(:booked_scheduled_phone_call) { create(:scheduled_phone_call, :booked, owner: pha, user: member_with_phone) }

      it_behaves_like 'cannot transition from', :cancel!, [:ended, :canceled]

      it 'changes the state to canceled' do
        booked_scheduled_phone_call.update_attributes! state_event: 'cancel', canceler: member_with_phone
        booked_scheduled_phone_call.should be_canceled
      end

      it 'sets the canceled time' do
        booked_scheduled_phone_call.update_attributes! state_event: 'cancel', canceler: member_with_phone
        booked_scheduled_phone_call.canceled_at.should == Time.now
      end

      it_behaves_like 'won\'t double book pha', :canceled
    end

    describe '#ended' do
      before do
        scheduled_phone_call.state = 'booked'
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

      it_behaves_like 'won\'t double book pha', :canceled
    end
  end

  describe '#scheduled_at_during_on_call' do
    let(:scheduled_phone_call) { create :scheduled_phone_call }
    let(:valid_work_time) do
      prev_global_time_zone = Time.zone
      Time.zone = ActiveSupport::TimeZone.new 'America/Los_Angeles'
      time = Time.roll_forward(100.days.from_now.in_time_zone(Time.zone)).on_call_start_oclock
      Time.zone = prev_global_time_zone
      time
    end

    context 'scheduled phone call is assigned' do
      let(:scheduled_phone_call) { create :scheduled_phone_call, :assigned }

      it 'allows scheduled at during work hours' do
        scheduled_phone_call.scheduled_at = valid_work_time
        scheduled_phone_call.should be_valid
      end

      it 'doesn\'t allow scheduled at after work hours' do
        scheduled_phone_call.scheduled_at = valid_work_time - 1.hours
        scheduled_phone_call.should_not be_valid
      end
    end

    context 'scheduled phone call is unassigned' do
      let(:scheduled_phone_call) { create :scheduled_phone_call }

      it 'allows scheduled at during work hours' do
        scheduled_phone_call.scheduled_at = valid_work_time
        scheduled_phone_call.should be_valid
      end

      it 'doesn\'t allow scheduled at after work hours' do
        scheduled_phone_call.scheduled_at = valid_work_time - 1.hours
        scheduled_phone_call.should_not be_valid
      end
    end

    context 'scheduled phone call is not unassigned or assigned' do
      let(:scheduled_phone_call) { create :scheduled_phone_call, :booked }

      it 'allows scheduled at during work hours' do
        scheduled_phone_call.scheduled_at = valid_work_time
        scheduled_phone_call.should be_valid
      end

      it 'allows scheduled at after work hours' do
        scheduled_phone_call.scheduled_at = valid_work_time - 1.hour
        scheduled_phone_call.should be_valid
      end
    end
  end
end

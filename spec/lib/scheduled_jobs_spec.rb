require 'spec_helper'

describe ScheduledJobs do
  before do
    Timecop.freeze
  end

  after do
    Timecop.return
  end

  describe '#downgrade_members' do
    let!(:expired_free_trial_member) { create :member, :trial, free_trial_ends_at: 1.day.ago }
    let!(:expiring_free_trial_member) { create :member, :trial, free_trial_ends_at: 1.hour.from_now }
    let!(:premium) { create :member, :premium }
    let!(:expired_premium) { create :member, :premium, subscription_ends_at: 2.days.ago }
    let!(:expiring_premium) { create :member, :premium, subscription_ends_at: 1.hour.from_now }

    context 'free trial members' do
      context 'offboarding free trial members' do
        before do
          Metadata.stub(:offboard_free_trial_members?) { true }
          Metadata.stub(:offboard_free_trial_start_date) { 1.day.ago }
        end

        it 'downgrades members with expired free trials' do
          ScheduledJobs.downgrade_members
          expired_free_trial_member.reload.status.should == 'free'
          expiring_free_trial_member.reload.status.should == 'trial'
          premium.reload.status.should == 'premium'
        end

        it 'ignores members who signed up before the offboard start date' do
          another_expired_free_trial_member = create :member, :trial, free_trial_ends_at: 3.days.ago, signed_up_at: 2.days.ago
          ScheduledJobs.downgrade_members
          expired_free_trial_member.reload.status.should == 'free'
          expiring_free_trial_member.reload.status.should == 'trial'
          another_expired_free_trial_member.reload.status.should == 'trial'
          premium.reload.status.should == 'premium'
        end
      end

      context 'not offboarding free trial members' do
        before do
          Metadata.stub(:offboard_free_trial_members?) { false }
        end

        it 'does nothing with expired free trials' do
          ScheduledJobs.downgrade_members
          expired_free_trial_member.reload.status.should == 'trial'
          expiring_free_trial_member.reload.status.should == 'trial'
          premium.reload.status.should == 'premium'
        end
      end
    end

    context 'expired members' do
      context 'offboarding expired members' do
        before do
          Metadata.stub(:offboard_expired_members?) { true }
        end

        it 'downgrades members with expired free trials' do
          ScheduledJobs.downgrade_members
          premium.reload.status.should == 'premium'
          expired_premium.reload.status.should == 'free'
          expiring_premium.reload.status.should == 'premium'
        end
      end

      context 'not offboarding expired members' do
        before do
          Metadata.stub(:offboard_expired_members?) { false }
        end

        it 'downgrades members with expired free trials' do
          ScheduledJobs.downgrade_members
          premium.reload.status.should == 'premium'
          expired_premium.reload.status.should == 'premium'
          expiring_premium.reload.status.should == 'premium'
        end
      end
    end
  end

  describe '#unforce_phas_off_call' do
    context 'metadata does not exist' do
      it 'does nothing if phas are not forced off call' do
        Metadata.any_instance.should_not_receive(:save!)
        ScheduledJobs.unforce_phas_off_call()
      end
    end

    context 'metadata exists' do
      context 'its false' do
        let!(:m) { Metadata.create mkey: :force_phas_off_call, mvalue: 'false' }

        it 'does nothing if phas are not forced off call' do
          Metadata.any_instance.should_not_receive(:save!)
          ScheduledJobs.unforce_phas_off_call()
        end
      end

      context 'its true' do
        let!(:m) { Metadata.create mkey: :force_phas_off_call, mvalue: 'true' }

        it 'does nothing' do
          Metadata.any_instance.should_not_receive(:save!)
          ScheduledJobs.unforce_phas_off_call()
          m = Metadata.find_by_mkey(:force_phas_off_call)
          m.should be_present
          m.mvalue.should == 'true'
        end

        context 'was set to true yesterday' do
          before do
            Timecop.freeze(1.day.ago)
          end

          it 'sets it to false' do
            ScheduledJobs.unforce_phas_off_call()
            m = Metadata.find_by_mkey(:force_phas_off_call)
            m.should be_present
            m.mvalue.should == 'false'
          end
        end
      end
    end
  end

  describe '#alert_stakeholders_when_no_pha_on_call' do
    context 'phas on call' do
      before do
        Role.stub_chain(:pha, :on_call?) { true }
      end

      context 'some phas on call' do
        before do
          Role.stub_chain(:pha, :users) do
            o = Object.new
            o.stub(:where).with(on_call: true) do
              o_o = Object.new
              o_o.stub(:count) { 1 }
              o_o
            end
            o
          end
        end

        it 'does nothing' do
          TwilioModule.should_not_receive :message
          ScheduledJobs.alert_stakeholders_when_no_pha_on_call
        end
      end

      context 'no phas on call' do
        let(:stakeholders) { [build_stubbed(:member), build_stubbed(:pha_lead, text_phone_number: '1111111111'), build_stubbed(:pha_lead, text_phone_number: '4083913578')] }

        before do
          Role.stub_chain(:pha, :users) do
            o = Object.new
            o.stub(:where).with(on_call: true) do
              o_o = Object.new
              o_o.stub(:count) { 0 }
              o_o
            end
            o
          end
        end

        it 'sends a message to each stakeholder' do
          Role.stub(:pha_stakeholders) { stakeholders }
          TwilioModule.should_receive(:message).with(
            nil,
            "ALERT: No PHAs triaging!"
          )
          TwilioModule.should_receive(:message).with(
            '1111111111',
            "ALERT: No PHAs triaging!"
          )
          TwilioModule.should_receive(:message).with(
            '4083913578',
            "ALERT: No PHAs triaging!"
          )
          ScheduledJobs.alert_stakeholders_when_no_pha_on_call
        end
      end
    end

    context 'phas not on call' do
      before do
        Role.stub_chain(:pha, :on_call?) { false }
      end

      it 'does nothing' do
        TwilioModule.client.account.messages.should_not_receive :create
        ScheduledJobs.alert_stakeholders_when_no_pha_on_call
      end
    end
  end

  describe '#offboard_free_trial_members' do
    let!(:too_old_engaged_expired_member) { create :member, :trial, signed_up_at: Time.parse('2014-07-01 16:00:00 -07:00'), free_trial_ends_at: Time.parse('2014-07-28 12:00:00 -0700'), first_name: 'A' }
    let!(:old_engaged_expired_member) { create :member, :trial, signed_up_at: Time.parse('2014-07-31 16:00:00 -07:00'), free_trial_ends_at: Time.parse('2014-07-31 12:00:00 -0700'), first_name: 'B' }
    let!(:engaged_expired_member) { create :member, :trial, free_trial_ends_at: Time.parse('2014-08-04 12:00:00 -0700'), first_name: 'C' }
    let!(:unengaged_expired_member) { create :member, :trial, free_trial_ends_at: Time.parse('2014-08-04 12:00:00 -0700'), first_name: 'D' }
    let!(:expiring_member) { create :member, :trial, free_trial_ends_at: Time.parse('2014-08-05 12:00:00 -0700'), first_name: 'E' }
    let!(:another_expiring_member) { create :member, :trial, free_trial_ends_at: Time.parse('2014-09-05 12:00:00 -0700'), first_name: 'F' }
    let!(:premium_member) { create :member, :premium, first_name: 'G' }

    before do
      Timecop.freeze Time.parse('2014-08-01 16:00:00 -0700')
      Metadata.stub(:offboard_free_trial_start_date) { 2.days.ago }
      Metadata.stub(:offboard_free_trial_members) { 2.days.ago }

      ServiceType.create! name: 'member offboarding', bucket: 'engagement'

      # Make engaged members engaged
      create(:user_request, user: engaged_expired_member)
      create(:user_request, user: too_old_engaged_expired_member)
      create(:user_request, user: old_engaged_expired_member)
    end

    after do
      Timecop.return
    end

    context 'offboarding free trial members' do
      before do
        Metadata.stub(:offboard_free_trial_members?) { true }
      end

      it 'offboards free trial members' do
        ScheduledJobs.offboard_free_trial_members

        OffboardMemberTask.where(member_id: too_old_engaged_expired_member).count.should == 0
        OffboardMemberTask.where(member_id: old_engaged_expired_member).count.should == 1
        OffboardMemberTask.where(member_id: engaged_expired_member).count.should == 1
        OffboardMemberTask.where(member_id: unengaged_expired_member).count.should == 0
        OffboardMemberTask.where(member_id: expiring_member).count.should == 0
        OffboardMemberTask.where(member_id: another_expiring_member).count.should == 0
        OffboardMemberTask.where(member_id: premium_member).count.should == 0
      end
    end

    context 'not offboarding free trial members' do
      before do
        Metadata.stub(:offboard_free_trial_members?) { false }
      end

      it 'does nothing' do
        Member.should_not_receive(:where)
        ScheduledJobs.offboard_free_trial_members

        OffboardMemberTask.where(member_id: too_old_engaged_expired_member).count.should == 0
        OffboardMemberTask.where(member_id: old_engaged_expired_member).count.should == 0
        OffboardMemberTask.where(member_id: engaged_expired_member).count.should == 0
        OffboardMemberTask.where(member_id: unengaged_expired_member).count.should == 0
        OffboardMemberTask.where(member_id: expiring_member).count.should == 0
        OffboardMemberTask.where(member_id: another_expiring_member).count.should == 0
        OffboardMemberTask.where(member_id: premium_member).count.should == 0
      end
    end
  end

  describe '#unforce_phas_on_call' do
    context 'metadata does not exist' do
      it 'does nothing if phas are not forced on call' do
        Metadata.any_instance.should_not_receive(:save!)
        ScheduledJobs.unforce_phas_on_call()
      end
    end

    context 'metadata exists' do
      context 'its false' do
        let!(:m) { Metadata.create mkey: :force_phas_on_call, mvalue: 'false' }

        it 'does nothing if phas are not forced on call' do
          Metadata.any_instance.should_not_receive(:save!)
          ScheduledJobs.unforce_phas_on_call()
        end
      end

      context 'its true' do
        let!(:m) { Metadata.create mkey: :force_phas_on_call, mvalue: 'true' }

        context 'past 9PM' do
          before do
            Timecop.freeze Time.parse('October 29, 2014, 9:00PM PDT')
          end

          after do
            Timecop.return
          end

          it 'sets it to false' do
            ScheduledJobs.unforce_phas_on_call
            m = Metadata.find_by_mkey :force_phas_on_call
            m.should be_present
            m.mvalue.should == 'false'
          end
        end

        context 'before 9PM' do
          before do
            Timecop.freeze Time.parse('October 29, 2014, 8:55PM PDT')
          end

          after do
            Timecop.return
          end

          it 'does nothing' do
            Metadata.any_instance.should_not_receive :save!
            ScheduledJobs.unforce_phas_on_call
            m = Metadata.find_by_mkey :force_phas_on_call
            m.should be_present
            m.mvalue.should == 'true'
          end
        end
      end
    end
  end

  describe '#alert_stakeholders_when_phas_forced_on_call' do
    context 'phas forced off call' do
      let(:stakeholders) { [build_stubbed(:member), build_stubbed(:pha_lead, text_phone_number: '1111111111'), build_stubbed(:pha_lead, text_phone_number: '4083913578')] }
      before do
        Metadata.stub(:force_phas_on_call?) { true }
      end

      context 'during business time' do
        before do
          Time.any_instance.stub(:business_time?) { true }
        end

        it 'does nothing' do
          TwilioModule.should_not_receive :message
          ScheduledJobs.alert_stakeholders_when_phas_forced_on_call
        end
      end

      context 'not during business time' do
        before do
          Time.any_instance.stub(:business_time?) { false }
        end

        it 'sends a message to each stakeholder' do
          Role.stub(:pha_stakeholders) { stakeholders }
          TwilioModule.should_receive(:message).with(
            nil,
            "ALERT: PHAs are currently forced on call till 9PM PDT."
          )
          TwilioModule.should_receive(:message).with(
            '1111111111',
            "ALERT: PHAs are currently forced on call till 9PM PDT."
          )
          TwilioModule.should_receive(:message).with(
            '4083913578',
            "ALERT: PHAs are currently forced on call till 9PM PDT."
          )
          ScheduledJobs.alert_stakeholders_when_phas_forced_on_call
        end
      end
    end

    context 'phas not forced off call' do
      before do
        Metadata.stub(:force_phas_on_call?) { false }
      end

      it 'does nothing' do
        TwilioModule.should_not_receive :message
        ScheduledJobs.alert_stakeholders_when_phas_forced_on_call
      end
    end
  end

  describe '#notify_lack_of_tasks' do
    context 'metadata does not exists' do

      it 'does nothing' do
        Member.should_not_receive :where
        ScheduledJobs.notify_lack_of_tasks
      end
    end
    context 'metadata exists' do
      context 'metadata is false' do
        before do
          Metadata.stub(:notify_lack_of_tasks?) { false }
        end

        it 'does nothing' do
          Member.should_not_receive :where
          ScheduledJobs.notify_lack_of_tasks
        end
      end

      context 'metadata is true' do
        let!(:premium_member) {create :member, :premium, first_name: 'a'}
        let!(:other_premium_member) {create :member, :premium, first_name: 'b'}
        let!(:task) {create :member_task, member: other_premium_member}
        let!(:free_member) {create :member, :free, first_name: 'c'}
        let!(:message) {create :message, user: premium_member}

        before do
          Metadata.stub(:notify_lack_of_tasks?) { true }
        end

        it 'should run create_if_member_has_no_tasks for every premium_states member' do
          AddTasksTask.should_receive(:create_if_member_has_no_tasks).with(premium_member)
          AddTasksTask.should_not_receive(:create_if_member_has_no_tasks).with(other_premium_member)
          AddTasksTask.should_not_receive(:create_if_member_has_no_tasks).with(free_member)
          ScheduledJobs.notify_lack_of_tasks
        end
      end
    end
  end


  describe '#notify_lack_of_messages' do
    context 'metadata does not exists' do

      it 'does nothing' do
        Member.should_not_receive :where
        ScheduledJobs.notify_lack_of_messages
      end
    end

    context 'metadata exists' do
      context 'metadata is false' do
        before do
          Metadata.stub(:notify_lack_of_messages?) { false }
        end

        it 'does nothing' do
          Member.should_not_receive :where
          ScheduledJobs.notify_lack_of_messages
        end
      end
    end

    context 'metadata is true' do
      before do
        Metadata.stub(:notify_lack_of_messages?) { true }
      end

      context 'with an unengaged premium member' do
        let!(:unengaged_member) { create :member, :premium, first_name: 'c', last_contact_at: 2.weeks.ago }
        let!(:message) { create :message, user: unengaged_member }

        it 'runs create_task_for_member for every premium_states member' do
          MessageMemberTask.should_receive(:create_task_for_member).with(unengaged_member)
          ScheduledJobs.notify_lack_of_messages
        end
      end

      context 'with a trial member' do
        let!(:member) { create(:member, :trial, last_contact_at: 2.weeks.ago) }
        let!(:scheduled_message) { create(:scheduled_message, recipient: member, reference_event: :free_trial_ends_at, reference: member, relative_days: 0) }
        let!(:message) { create :message, user: member }

        it 'runs create_task_for_member if the user has a scheduled_communication with a reference_event' do
          MessageMemberTask.should_receive(:create_task_for_member).with(member)
          ScheduledJobs.notify_lack_of_messages
        end
      end
    end
  end

  describe '#timeout_messages' do
    let!(:pha) { create :pha }
    let!(:session) { create :session, member: pha, device_os: nil, disabled_at: 10.minutes.ago }
    let!(:message_task) { create :message_task, :claimed, owner: pha, assignor: pha}

    it 'should unstart claimed messsages for PHAs that do not have an active session' do
      expect(message_task).to be_claimed
      expect(message_task.owner).to eq(pha)
      ScheduledJobs.timeout_messages
      message_task.reload
      expect(message_task).to be_unstarted
      expect(message_task.owner).to eq(nil)
    end
  end

  describe '#update_gravatar' do
    context 'avatar_url_override is nil' do
      let!(:member) { create :member }
      it 'it should update member\'s gravatar if possible' do
        expect(member.avatar_url_override).to eq(nil)
      end
    end

    context 'avatar_url_override is set to non-gravatar url' do
      let!(:member) {create :member, avatar_url_override: 'blah'}
      it 'it should note update member\'s avatar if avatar_url_override is filled with something else not from gravatar' do
        expect(member.avatar_url_override).to eq('blah')
      end
    end

    context 'avatar_url_override is set to gravatar url' do
      let!(:member) {create :member, avatar_url_override: 'https://secure.gravatar.com/avatar/blah.png'}
      it 'it should note update member\'s gravatar' do
        expect(member.avatar_url_override).to eq(nil)
      end
    end
  end
end

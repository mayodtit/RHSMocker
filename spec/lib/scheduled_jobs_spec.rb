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

  describe '#alert_stakeholders_when_phas_forced_off_call' do
    context 'phas forced off call' do
      let(:stakeholders) { [build_stubbed(:member), build_stubbed(:pha_lead, work_phone_number: '1111111111'), build_stubbed(:pha_lead, work_phone_number: '4083913578')] }
      before do
        Metadata.stub(:force_phas_off_call?) { true }
      end

      it 'sends a message to each stakeholder' do
        Role.stub(:pha_stakeholders) { stakeholders }
        TwilioModule.should_receive(:message).with(
          nil,
          "ALERT: PHAs are currently forced after hours. This can be changed via the Care Portal."
        )
        TwilioModule.should_receive(:message).with(
          '1111111111',
          "ALERT: PHAs are currently forced after hours. This can be changed via the Care Portal."
        )
        TwilioModule.should_receive(:message).with(
          '4083913578',
          "ALERT: PHAs are currently forced after hours. This can be changed via the Care Portal."
        )
        ScheduledJobs.alert_stakeholders_when_phas_forced_off_call
      end
    end

    context 'phas not forced off call' do
      before do
        Metadata.stub(:force_phas_off_call?) { false }
      end

      it 'does nothing' do
        TwilioModule.should_not_receive :message
        ScheduledJobs.alert_stakeholders_when_phas_forced_off_call
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
        let(:stakeholders) { [build_stubbed(:member), build_stubbed(:pha_lead, work_phone_number: '1111111111'), build_stubbed(:pha_lead, work_phone_number: '4083913578')] }

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

  describe '#transition_scheduled_communications' do
    context 'with scheduled message' do
      let!(:scheduled_message) { create(:scheduled_message, publish_at: Time.now - 1.minute) }
      let!(:future_scheduled_message) { create(:scheduled_message, publish_at: Time.now + 10.minute) }

      it 'sends scheduled messages in the past' do
        expect(scheduled_message.state?(:scheduled)).to be_true
        described_class.transition_scheduled_communications
        expect(scheduled_message.reload.state?(:delivered)).to be_true
        future_scheduled_message.reload.should be_scheduled
      end

      it 'skips messages that have been delivered' do
        ScheduledCommunication.any_instance.stub(:reload) {
          scheduled_message.stub(:delivered?) { true }
          scheduled_message
        }

        scheduled_message.should_not_receive(:deliver!)
        described_class.transition_scheduled_communications
      end
    end

    context 'with held message' do
      let!(:scheduled_message) { create(:scheduled_message, :held, publish_at: Time.now - 1.minute) }
      let!(:future_held_message) { create(:scheduled_message, publish_at: Time.now + 10.minute) }

      before do
        future_held_message.hold!
      end

      it 'cancels held messages in the past' do
        expect(scheduled_message.state?(:held)).to be_true
        described_class.transition_scheduled_communications
        expect(scheduled_message.reload.state?(:canceled)).to be_true
        future_held_message.reload.should be_held
      end

      it 'skips messages that have been held' do
        ScheduledCommunication.any_instance.stub(:reload) {
          scheduled_message.stub(:canceled?) { true }
          scheduled_message
        }

        scheduled_message.should_not_receive(:cancel!)
        described_class.transition_scheduled_communications
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

    let!(:consult) { create :consult, initiator: too_old_engaged_expired_member, subject: too_old_engaged_expired_member }
    let!(:consult) { create :consult, initiator: old_engaged_expired_member, subject: old_engaged_expired_member }
    let!(:consult) { create :consult, initiator: engaged_expired_member, subject: engaged_expired_member }

    before do
      Timecop.freeze Time.parse('2014-08-01 16:00:00 -0700')
      Metadata.stub(:offboard_free_trial_start_date) { 2.days.ago }
      Metadata.stub(:offboard_free_trial_members) { 2.days.ago }

      ServiceType.create! name: 'member offboarding', bucket: 'engagement'

      # Make engaged members engaged
      Message.create! user: engaged_expired_member, consult: consult, text: 'test.'
      Message.create! user: engaged_expired_member, consult: consult, text: 'test.'
      engaged_expired_member.should be_engaged

      Message.create! user: too_old_engaged_expired_member, consult: consult, text: 'test.'
      Message.create! user: too_old_engaged_expired_member, consult: consult, text: 'test.'
      too_old_engaged_expired_member.should be_engaged

      Message.create! user: old_engaged_expired_member, consult: consult, text: 'test.'
      Message.create! user: old_engaged_expired_member, consult: consult, text: 'test.'
      old_engaged_expired_member.should be_engaged
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
end

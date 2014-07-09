require 'spec_helper'

describe ScheduledJobs do
  before do
    Timecop.freeze
  end

  after do
    Timecop.return
  end

  describe '#unset_premium_for_expired_subscriptions' do
    it 'should unset premium flag for users with expired subscriptions' do
      u1 = create(:member, is_premium: true, free_trial_ends_at: 1.day.ago)
      u2 = create(:member, is_premium: true, free_trial_ends_at: 1.hour.from_now)
      u3 = create(:member, is_premium: true, free_trial_ends_at: nil)

      ScheduledJobs.unset_premium_for_expired_subscriptions
      u1.reload.is_premium.should be_false
      u1.reload.free_trial_ends_at.should be_nil
      u2.reload.is_premium.should be_true
      u2.reload.free_trial_ends_at.should_not be_nil
      u3.reload.is_premium.should be_true
      u3.reload.free_trial_ends_at.should be_nil
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

  describe '#transition_scheduled_messages' do
    context 'with scheduled message' do
      let!(:scheduled_message) { create(:scheduled_message, publish_at: Time.now - 1.minute) }

      it 'sends scheduled messages in the past' do
        expect(scheduled_message.state?(:scheduled)).to be_true
        described_class.transition_scheduled_messages
        expect(scheduled_message.reload.state?(:sent)).to be_true
      end
    end

    context 'with held message' do
      let!(:scheduled_message) { create(:scheduled_message, :held, publish_at: Time.now - 1.minute) }

      it 'cancels held messages in the past' do
        expect(scheduled_message.state?(:held)).to be_true
        described_class.transition_scheduled_messages
        expect(scheduled_message.reload.state?(:canceled)).to be_true
      end
    end
  end

  describe '#offboard_free_trial_members' do
    let(:engaged_member) { build_stubbed :member }
    let(:unengaged_member) { build_stubbed :member }
    let(:unengaged_member) { build_stubbed :member }
    let(:task) { build_stubbed :offboard_member_task }

    before do
      Metadata.stub(:offboard_free_trial_members?) { true }

      engaged_member.stub(:engaged?) { true }
      unengaged_member.stub(:engaged?) { false }

      Member.stub(:where).with('free_trial_ends_at < ?', Time.now - 24.hours) { [engaged_member, unengaged_member] }

      OffboardMemberTask.stub(:create) { task }
      task.stub(:valid?) { true }

      Timecop.freeze
    end

    after do
      Timecop.return
    end

    it 'iterates through all engaged members who\'s free trial ends in 24 hours or less' do
      Member.should_receive(:where).with('free_trial_ends_at < ?', Time.now - OffboardMemberTask::OFFBOARDING_WINDOW) do
        o = Object.new
        o.should_receive(:each)
        o
      end
      ScheduledJobs.offboard_free_trial_members
    end

    context 'member is engaged' do
      it 'creates on offboarding task' do
        OffboardMemberTask.stub(:create_if_only_within_offboarding_window).with(engaged_member) { task }
        ScheduledJobs.offboard_free_trial_members
      end

      context 'offboarding task errors out' do
        before do
          OffboardMemberTask.stub(:create_if_only_within_offboarding_window).with(engaged_member) { task }
          task.stub(:valid?) { false }
        end

        it 'logs an error' do
          Rails.stub(:logger) do
            o = Object.new
            o.should_receive(:error)
            o
          end
          ScheduledJobs.offboard_free_trial_members
        end
      end
    end

    context 'member is not engaged' do
      it 'does nothing' do
        OffboardMemberTask.should_not_receive(:create_if_only_within_offboarding_window).with(unengaged_member)
        ScheduledJobs.offboard_free_trial_members
      end
    end
  end
end

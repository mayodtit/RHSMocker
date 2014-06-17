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
end

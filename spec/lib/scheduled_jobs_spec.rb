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

  describe '#alert_leads_when_phas_forced_off_call' do
    let(:messages) { Object.new }

    before do
      PhoneCall.stub_chain(:twilio, :account, :messages) { messages }
    end

    context 'phas forced off call' do
      let(:stakeholders) { [build_stubbed(:member), build_stubbed(:pha_lead, work_phone_number: '1111111111'), build_stubbed(:pha_lead, work_phone_number: '4083913578')] }
      before do
        Metadata.stub(:force_phas_off_call?) { true }
      end

      it 'sends a message to each stakeholder with a work phone' do
        Role.stub(:pha_stakeholders) { stakeholders }
        messages.should_receive(:create).with(
          from: PhoneNumberUtil::format_for_dialing(SERVICE_ALERT_PHONE_NUMBER),
          to: PhoneNumberUtil::format_for_dialing('1111111111'),
          body: "test - PHAs are currently forced after hours. This can be changed via the Care Portal."
        )
        messages.should_receive(:create).with(
          from: PhoneNumberUtil::format_for_dialing(SERVICE_ALERT_PHONE_NUMBER),
          to: PhoneNumberUtil::format_for_dialing('4083913578'),
          body: "test - PHAs are currently forced after hours. This can be changed via the Care Portal."
        )
        ScheduledJobs.alert_leads_when_phas_forced_off_call
      end
    end

    context 'phas not forced off call' do
      before do
        Metadata.stub(:force_phas_off_call?) { false }
      end

      it 'does nothing' do
        messages.should_not_receive :create
        ScheduledJobs.alert_leads_when_phas_forced_off_call
      end
    end
  end
end

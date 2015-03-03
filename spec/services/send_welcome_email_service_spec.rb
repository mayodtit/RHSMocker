require 'spec_helper'

describe SendWelcomeEmailService do
  context 'with a trial member' do
    let!(:user) { create(:member, :trial) }

    it 'queues a Mails::MeetYourPhaJob' do
      Mails::MeetYourPhaJob.should_receive(:create).and_call_original
      expect{ described_class.new(user).call }.to change(Delayed::Job, :count).by(1)
    end

    context 'in the mayo pilot' do
      let!(:provider) { create(:member) }
      let!(:onboarding_group) { create(:onboarding_group, mayo_pilot: true, provider: provider) }

      before do
        user.update_attributes(onboarding_group: onboarding_group)
      end

      it 'queues up a Mails::MayoPilotMeetYourPhaJob' do
        Mails::MayoPilotMeetYourPhaJob.should_receive(:create).and_call_original
        expect{ described_class.new(user).call }.to change(Delayed::Job, :count).by(1)
      end
    end
  end

  context 'with a free member' do
    let!(:user) { create(:member, :free) }

    it 'queues a Mails::WelcomeToBetterFreeTrialJob' do
      Mails::WelcomeToBetterFreeTrialJob.should_receive(:create).and_call_original
      expect{ described_class.new(user).call }.to change(Delayed::Job, :count).by(1)
    end
  end

  context 'with a premium member' do
    let!(:user) { create(:member, :premium) }

    it 'queues a Mails::MeetYourPhaMonthTrialJob' do
      Mails::MeetYourPhaMonthTrialJob.should_receive(:create).and_call_original
      expect{ described_class.new(user).call }.to change(Delayed::Job, :count).by(1)
    end
  end
end

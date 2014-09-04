require 'spec_helper'

describe Notifications::WelcomeCallCompletionJob do
  let!(:user) { create(:member) }

  before do
    Timecop.freeze(Date.today.to_time)
  end

  after do
    Timecop.return
  end

  describe '#create' do
    it 'enqueues the job for now' do
      expect{ described_class.create(user.id) }.to change(Delayed::Job, :count).by(1)
      job = Delayed::Job.last
      expect(job.run_at).to eq(Time.now)
    end
  end

  describe '#perform' do
    context 'user without apns_token' do
      it 'does not call APNS' do
        APNS.should_not_receive(:send_notification)
        described_class.new(user.id).perform
      end
    end

    context 'user with apns_token' do
      let(:user) { create(:member) }
      let!(:session) { user.sessions.create(apns_token: 'test_token') }

      it 'calls APNS' do
        APNS.should_receive(:send_notification)
        described_class.new(user.id).perform
      end
    end
  end
end

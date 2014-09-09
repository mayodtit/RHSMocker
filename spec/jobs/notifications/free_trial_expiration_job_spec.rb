require 'spec_helper'

describe Notifications::FreeTrialExpirationJob do
  let!(:user) { create(:member) }

  before do
    Timecop.freeze(Date.today.to_time)
  end

  after do
    Timecop.return
  end

  describe '#create' do
    it 'enqueues the job for now' do
      expect{ described_class.create(user.id, 4) }.to change(Delayed::Job, :count).by(1)
      job = Delayed::Job.last
      expect(job.run_at).to eq(Time.now)
      expect(job.queue).to eq("FreeTrialExpirationJob-UserId-#{user.id}")
    end

    it 'deletes existing jobs for the same user and consult' do
      expect{ described_class.create(user.id, 4) }.to change(Delayed::Job, :count).by(1)
      first_job = Delayed::Job.last
      expect{ described_class.create(user.id, 4) }.to_not change(Delayed::Job, :count)
      expect(Delayed::Job.find_by_id(first_job.id)).to be_nil
    end
  end

  describe '#perform' do
    context 'user without apns_token' do
      it 'does not call APNS' do
        APNS.should_not_receive(:send_notification)
        described_class.new(user.id, 4).perform
      end
    end

    context 'user with apns_token' do
      let(:user) { create(:member) }
      let!(:session) { user.sessions.create(apns_token: 'test_token') }

      it 'calls APNS' do
        APNS.should_receive(:send_notification)
        described_class.new(user.id, 4).perform
      end
    end
  end
end

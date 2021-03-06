require 'spec_helper'

describe Notifications::NewMessageJob do
  let!(:user) { create(:member) }
  let!(:consult) { create(:consult, initiator: user) }

  before do
    Consult.skip_callback(:create, :after, :create_task) # don't create extra jobs
    Timecop.freeze(Date.today.to_time)
  end

  after do
    Timecop.return
  end

  describe '#create' do
    it 'enqueues the job for now' do
      expect{ described_class.create(user.id, consult.id) }.to change(Delayed::Job, :count).by(1)
      job = Delayed::Job.last
      expect(job.run_at).to eq(Time.now)
      expect(job.queue).to eq("NewMessageJob-UserId-#{user.id}-ConsultId-#{consult.id}")
    end
  end

  describe '#perform' do
    context 'user without apns_token' do
      it 'does not call APNS' do
        APNS.should_not_receive(:send_notification)
        described_class.new(user.id, consult.id).perform
      end
    end

    context 'user with apns_token' do
      let(:user) { create(:member) }
      let!(:session) { user.sessions.create(apns_token: 'test_token') }

      it 'calls APNS' do
        APNS.should_receive(:send_notification)
        described_class.new(user.id, consult.id).perform
      end
    end

    context 'user without gcm_id' do
      it 'does not call GCM' do
        GCM.should_not_receive(:alert_new_message)
        described_class.new(user.id, consult.id).perform
      end
    end

    context 'user with gcm_id' do
      let(:user) { create(:member) }
      let!(:session) { user.sessions.create(gcm_id: 'test_token') }

      it 'calls GCM' do
        GCM.should_receive(:alert_new_message)
        described_class.new(user.id, consult.id).perform
      end
    end
  end
end

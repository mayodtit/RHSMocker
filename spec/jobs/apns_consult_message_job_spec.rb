require 'spec_helper'

describe ApnsConsultMessageJob  do
  let(:user) { create(:member) }
  let(:consult) { create(:consult, initiator: user) }

  before do
    Consult.skip_callback(:create, :after, :create_task) # don't create extra jobs
    Timecop.freeze(Date.today.to_time)
  end

  after do
    Timecop.return
  end

  describe '#create' do
    it 'enqueues the job 5 minutes from now' do
      expect{ described_class.create(user.id, consult.id) }.to change(Delayed::Job, :count).by(1)
      job = Delayed::Job.last
      expect(job.run_at).to eq(5.minutes.from_now)
      expect(job.queue).to eq("ApnsConsultMessageJob-UserId-#{user.id}-ConsultId-#{consult.id}")
    end

    it 'deletes existing jobs for the same user and consult' do
      expect{ described_class.create(user.id, consult.id) }.to change(Delayed::Job, :count).by(1)
      first_job = Delayed::Job.last
      described_class.create(user.id, consult.id)
      expect(Delayed::Job.find_by_id(first_job.id)).to be_nil
      expect(Delayed::Job.count).to eq(1)
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
      let(:user) { create(:member, apns_token: 'test_token') }

      it 'calls APNS' do
        APNS.should_receive(:send_notification)
        described_class.new(user.id, consult.id).perform
      end
    end
  end
end

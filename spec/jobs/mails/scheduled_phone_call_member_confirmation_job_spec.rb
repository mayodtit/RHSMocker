require 'spec_helper'

describe Mails::ScheduledPhoneCallMemberConfirmationJob do
  let!(:pha) { create :pha }
  let!(:user) { create :member, pha: pha }
  let!(:scheduled_phone_call) { create(:scheduled_phone_call, :booked, user: user ) }

  before do
    Timecop.freeze(Date.today.to_time)
  end

  after do
    Timecop.return
  end

  describe '::create' do
    it 'enqueues the job to run now' do
      expect{ described_class.create(scheduled_phone_call.id) }.to change(Delayed::Job, :count).by(1)
      job = Delayed::Job.last
      expect(job.run_at).to eq(Time.now)
    end
  end

  describe '#perform' do
    it 'works' do
      described_class.new(scheduled_phone_call.id).perform
    end
  end
end

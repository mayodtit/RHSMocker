require 'spec_helper'

describe ReferralCardJob do
  let!(:user) { create(:member) }

  before do
    Timecop.freeze(Date.today.to_time)
  end

  after do
    Timecop.return
  end

  describe '::create' do
    it 'enqueues the job to run in 5 days' do
      expect{ described_class.create(user.id) }.to change(Delayed::Job, :count).by(1)
      job = Delayed::Job.last
      expect(job.run_at).to eq(5.days.from_now)
    end
  end

  describe '#perform' do
    it 'works' do
      described_class.new(user.id).perform
    end
  end
end

require 'spec_helper'

describe Mails::NotifyReferrerOfSignUpJob do
  let!(:referrer) { create(:member, :premium) }
  let(:referee) { create(:member)}

  before do
    Timecop.freeze(Date.today.to_time)
  end

  after do
    Timecop.return
  end

  describe '::create' do
    it 'enqueues the job to run now' do
      expect{ described_class.create(referrer.id, referee.id) }.to change(Delayed::Job, :count).by(1)
      job = Delayed::Job.last
      expect(job.run_at).to eq(Time.now)
    end
  end

  describe '#perform' do
    it 'works' do
      described_class.new(referrer.id, referee.id).perform
    end
  end
end

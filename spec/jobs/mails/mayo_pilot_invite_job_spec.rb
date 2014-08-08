require 'spec_helper'

describe Mails::MayoPilotInviteJob  do
  let!(:provider) { create(:member) }
  let!(:member) { create(:member, :invited) }

  before do
    Timecop.freeze(Date.today.to_time)
  end

  after do
    Timecop.return
  end

  describe '::create' do
    it 'enqueues the job to run now' do
      expect{ described_class.create(member.id, provider.id) }.to change(Delayed::Job, :count).by(1)
      job = Delayed::Job.last
      expect(job.run_at).to eq(Time.now)
    end
  end

  describe '#perform' do
    it 'works' do
      described_class.new(member.id, provider.id).perform
    end
  end
end

require 'spec_helper'

describe Mails::WelcomeToPremiumJob  do
  let!(:pha) { create(:pha, email: 'clare@getbetter.com') }
  let!(:member) { create(:member, pha: pha) }

  before do
    Timecop.freeze(Date.today.to_time)
  end

  after do
    Timecop.return
  end

  describe '::create' do
    it 'enqueues the job to run now' do
      expect{ described_class.create(member.id) }.to change(Delayed::Job, :count).by(1)
      job = Delayed::Job.last
      expect(job.run_at).to eq(Time.now)
    end
  end

  describe '#perform' do
    it 'works' do
      described_class.new(member.id).perform
    end
  end
end

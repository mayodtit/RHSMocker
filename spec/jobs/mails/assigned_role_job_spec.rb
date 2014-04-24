require 'spec_helper'

describe Mails::AssignedRoleJob do
  let!(:member) { create(:member) }
  let!(:invitor) { create(:member) }
  let(:url) { 'http://www.getbetter.com/whatever' }

  before do
    Timecop.freeze(Date.today.to_time)
  end

  after do
    Timecop.return
  end

  describe '::create' do
    it 'enqueues the job to run now' do
      expect{ described_class.create(member.id, url, invitor.full_name) }.to change(Delayed::Job, :count).by(1)
      job = Delayed::Job.last
      expect(job.run_at).to eq(Time.now)
    end
  end

  describe '#perform' do
    it 'works' do
      described_class.new(member.id, url, invitor.full_name).perform
    end
  end
end

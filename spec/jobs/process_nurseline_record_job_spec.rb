require 'spec_helper'

describe ProcessNurselineRecordJob do
  let!(:nurseline_record) { create(:nurseline_record) }

  before do
    Timecop.freeze(Date.today.to_time)
  end

  after do
    Timecop.return
  end

  describe '::create' do
    it 'enqueues the job to run now' do
      expect{ described_class.create(nurseline_record.id) }.to change(Delayed::Job, :count).by(1)
      job = Delayed::Job.last
      expect(job.run_at).to eq(Time.now)
    end
  end

  describe '#perform' do
    it 'works' do
      ParsedNurselineRecord.should_receive(:create_from_nurseline_record).once
      described_class.new(nurseline_record.id).perform
    end
  end
end

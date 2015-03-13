require 'spec_helper'

describe Mails::SendBusinessOnBoardInvitationEmailJob do
  let!(:enrollment) { create(:enrollment, email: 'test@test.com') }
  let(:link) { 'test link' }
  let(:uout) {'test uout'}

  before do
    Timecop.freeze(Date.today.to_time)
  end

  after do
    Timecop.return
  end

  describe '::create' do
    it 'enqueues the job to run now' do
      expect{ described_class.create(enrollment.id, link, uout) }.to change(Delayed::Job, :count).by(1)
      job = Delayed::Job.last
      expect(job.run_at).to eq(Time.now)
    end
  end

  describe '#perform' do
    it 'works' do
      described_class.new(enrollment.id, link, uout).perform
    end
  end
end
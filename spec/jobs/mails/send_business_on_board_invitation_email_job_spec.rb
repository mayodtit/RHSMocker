require 'spec_helper'

describe Mails::SendBusinessOnBoardInvitationEmailJob do
  let!(:enrollment) { create(:enrollment, email: 'test@test.com') }
  let(:link) { 'test link' }
  let(:unique_on_boarding_user_token) {'test_uout'}

  before do
    Timecop.freeze(Date.today.to_time)
  end

  after do
    Timecop.return
  end

  describe '::create' do
    it 'enqueues the job to run now' do
      expect{ described_class.create(enrollment.id, link, unique_on_boarding_user_token) }.to change(Delayed::Job, :count).by(1)
      job = Delayed::Job.last
      expect(job.run_at).to eq(Time.now)
    end
  end

  describe '#perform' do
    it 'works' do
      described_class.new(enrollment.id, link, unique_on_boarding_user_token).perform
    end
  end
end

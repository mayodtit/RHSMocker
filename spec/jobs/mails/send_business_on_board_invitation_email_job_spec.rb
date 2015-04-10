require 'spec_helper'

describe Mails::SendBusinessOnBoardInvitationEmailJob do
  let!(:enrollment) { create(:enrollment, unique_on_boarding_user_token: 'test', email: 'test@test.com') }
  let(:link) { 'test link' }

  before do
    Timecop.freeze(Date.today.to_time)
  end

  after do
    Timecop.return
  end

  describe '::create' do
    it 'enqueues the job to run now' do
      expect{ described_class.create(enrollment.unique_on_boarding_user_token, link) }.to change(Delayed::Job, :count).by(1)
      job = Delayed::Job.last
      expect(job.run_at).to eq(Time.now)
    end
  end

  describe '#perform' do
    it 'works' do
      described_class.new(enrollment.unique_on_boarding_user_token, link).perform
    end
  end
end

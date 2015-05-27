require 'spec_helper'

describe KinsightsSignupJob do
  let(:user) { create(:member) }

  before do
    Timecop.freeze(Date.today.to_time)
  end

  after do
    Timecop.return
  end

  describe '::create' do
    it 'enqueues the job to run now' do
      expect{ described_class.create(user.id) }.to change(Delayed::Job, :count).by(1)
      job = Delayed::Job.last
      expect(job.run_at).to eq(Time.now)
    end
  end

  describe '#perform' do
    let(:kinsights_signup_service) { double('kinsights signup service', call: true) }

    it 'works' do
      KinsightsSignupService.should_receive(:new).with(user, user.kinsights_token).once.and_return(kinsights_signup_service)
      described_class.new(user.id).perform
    end
  end
end

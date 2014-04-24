require 'spec_helper'

describe Mails::ResetPasswordJob do
  let!(:member) { create(:member, reset_password_token: 'BAADBEEFDEADBEEF') }

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

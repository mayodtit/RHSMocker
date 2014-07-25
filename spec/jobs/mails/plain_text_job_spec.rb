require 'spec_helper'

describe Mails::PlainTextJob  do
  let!(:sender) { create(:pha, email: 'clare@getbetter.com') }
  let!(:recipient) { create(:member, :premium, pha: sender) }
  let(:email_subject) { 'subject' }
  let(:text) { 'text' }

  before do
    Timecop.freeze(Date.today.to_time)
  end

  after do
    Timecop.return
  end

  describe '::create' do
    it 'enqueues the job to run now' do
      expect{ described_class.create(recipient.id, sender.id, email_subject, text) }.to change(Delayed::Job, :count).by(1)
      job = Delayed::Job.last
      expect(job.run_at).to eq(Time.now)
    end
  end

  describe '#perform' do
    it 'works' do
      described_class.new(recipient.id, sender.id, email_subject, text).perform
    end
  end
end

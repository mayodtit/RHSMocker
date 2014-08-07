require 'spec_helper'

describe ScheduledPlainTextEmail do
  before do
    Timecop.freeze(Date.today.to_time)
  end

  after do
    Timecop.return
  end

  it_has_a 'valid factory'
  it_has_a 'valid factory', :scheduled
  it_has_a 'valid factory', :held
  it_has_a 'valid factory', :delivered
  it_has_a 'valid factory', :canceled
  it_validates 'presence of', :sender
  it_validates 'presence of', :subject
  it_validates 'presence of', :text

  describe 'events' do
    describe '#deliver' do
      let!(:email) { create(:scheduled_plain_text_email, :scheduled) }

      it 'transitions from :scheduled to :delivered' do
        email.update_attributes!(state_event: :deliver)
        expect(email.state?(:delivered)).to be_true
      end

      it 'delays an email to be sent' do
        expect{ email.update_attributes!(state_event: :deliver) }.to change(Delayed::Job, :count).by(1)
        expect(email.delivered_at).to eq(Time.now)
      end
    end
  end
end

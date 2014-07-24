require 'spec_helper'

describe ScheduledTemplateEmail do
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
  it_validates 'presence of', :recipient
  it_validates 'presence of', :template

  describe 'events' do
    describe '#deliver' do
      let(:scheduled_email) { create(:scheduled_template_email, :scheduled) }

      it 'transitions from :scheduled to :delivered' do
        scheduled_email.update_attributes!(state_event: :deliver)
        expect(scheduled_email.state?(:delivered)).to be_true
      end

      it 'sends a scheduled_email to the consult' do
        Mails::AutomatedOnboardingSurveyJob.should_receive(:create).once
        scheduled_email.update_attributes!(state_event: :deliver)
        expect(scheduled_email.delivered_at).to eq(Time.now)
      end
    end
  end
end

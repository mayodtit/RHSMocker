require 'spec_helper'

describe ScheduledMessage do
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
  it_validates 'presence of', :text
  it_validates 'foreign key of', :message
  it_validates 'foreign key of', :content

  describe 'events' do
    describe '#deliver' do
      let(:message) { create(:scheduled_message, :scheduled) }

      it 'transitions from :scheduled to :delivered' do
        message.update_attributes!(state_event: :deliver)
        expect(message.state?(:delivered)).to be_true
      end

      it 'sends a message to the consult' do
        expect{ message.update_attributes!(state_event: :deliver) }.to change(Message, :count).by(1)
        expect(message.reload.message).to_not be_blank
        expect(message.delivered_at).to eq(Time.now)
      end
    end
  end
end

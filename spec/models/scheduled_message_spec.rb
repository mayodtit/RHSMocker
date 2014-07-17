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
  it_has_a 'valid factory', :sent
  it_has_a 'valid factory', :canceled
  it_validates 'presence of', :sender
  it_validates 'presence of', :consult
  it_validates 'presence of', :text

  describe 'states' do
    describe 'scheduled' do
      let(:message) { build_stubbed(:scheduled_message, :scheduled) }

      it 'validates publish_at' do
        expect(message).to be_valid
        message.publish_at = nil
        expect(message).to_not be_valid
        expect(message.errors[:publish_at]).to include("can't be blank")
      end

      it 'validates sent_at is nil' do
        expect(message).to be_valid
        message.sent_at = Time.now
        expect(message).to_not be_valid
        expect(message.errors[:sent_at]).to include('must be nil')
      end
    end

    describe 'sent' do
      let(:message) { build_stubbed(:scheduled_message, :sent) }

      it 'validates sent_at' do
        expect(message).to be_valid
        message.sent_at = nil
        expect(message).to_not be_valid
        expect(message.errors[:sent_at]).to include("can't be blank")
      end
    end
  end

  describe 'events' do
    describe '#send_message' do
      let(:message) { create(:scheduled_message, :scheduled) }

      it 'transitions from :scheduled to :sent' do
        message.update_attributes!(state_event: :send_message)
        expect(message.state?(:sent)).to be_true
      end

      it 'sends a message to the consult' do
        expect{ message.update_attributes!(state_event: :send_message) }.to change(Message, :count).by(1)
        expect(message.reload.message).to_not be_blank
        expect(message.sent_at).to eq(Time.now)
      end
    end
  end
end

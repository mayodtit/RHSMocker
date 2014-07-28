require 'spec_helper'

describe ScheduledCommunication do
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
  it_validates 'presence of', :recipient

  describe 'states' do
    describe 'scheduled' do
      let(:message) { build_stubbed(:scheduled_message, :scheduled) }

      it 'validates publish_at' do
        expect(message).to be_valid
        message.publish_at = nil
        expect(message).to_not be_valid
        expect(message.errors[:publish_at]).to include("can't be blank")
      end

      it 'validates delivered_at is nil' do
        expect(message).to be_valid
        message.delivered_at = Time.now
        expect(message).to_not be_valid
        expect(message.errors[:delivered_at]).to include('must be nil')
      end
    end

    describe 'delivered' do
      let(:message) { build_stubbed(:scheduled_message, :delivered) }

      it 'validates delivered_at' do
        expect(message).to be_valid
        message.delivered_at = nil
        expect(message).to_not be_valid
        expect(message.errors[:delivered_at]).to include("can't be blank")
      end
    end
  end
end

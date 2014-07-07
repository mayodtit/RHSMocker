require 'spec_helper'

describe MessageTemplate do
  before do
    Timecop.freeze(Date.today.to_time)
  end

  after do
    Timecop.return
  end

  it_has_a 'valid factory'
  it_validates 'presence of', :name
  it_validates 'presence of', :text
  it_validates 'uniqueness of', :name

  describe 'sending methods' do
    let(:message_template) { create(:message_template) }
    let(:sender) { create(:pha) }
    let(:consult) { create(:consult) }
    let(:publish_at) { Time.now + 1.day }

    describe '#create_message' do
      it 'sends a message' do
        message = message_template.create_message(sender, consult)
        expect(message).to be_persisted
        expect(message.user).to eq(sender)
        expect(message.consult).to eq(consult)
        expect(message.text).to eq(message_template.text)
      end
    end

    describe '#create_scheduled_message' do
      it 'schedules a message' do
        scheduled_message = message_template.create_scheduled_message(sender,
                                                                      consult,
                                                                      publish_at)
        expect(scheduled_message).to be_persisted
        expect(scheduled_message.sender).to eq(sender)
        expect(scheduled_message.consult).to eq(consult)
        expect(scheduled_message.publish_at).to eq(publish_at)
        expect(scheduled_message.text).to eq(message_template.text)
      end
    end
  end
end

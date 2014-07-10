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

      it 'replaces text' do
        MessageTemplate.should_receive(:formatted_text).with(sender, consult, message_template.text) { 'Test' }
        message = message_template.create_message(sender, consult)
        message.text.should == 'Test'
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

  describe '#formatted_text' do
    let(:consult) { build :consult }
    let(:sender) { build :pha }

    before do
      sender.stub(:first_name) { 'Kevin' }
    end

    it 'replaces member_first_name' do
      MessageTemplate.formatted_text(sender, consult, 'Hello *|member_first_name|*').should == "Hello #{consult.initiator.salutation}"
    end

    it 'replaces sender_first_name' do
      MessageTemplate.formatted_text(sender, consult, 'I am *|sender_first_name|*.').should == 'I am Kevin.'
    end

    context 'merge tags not defined' do
      context 'initiator is missing' do
        before do
          consult.initiator.stub(:salutation) { '' }
        end

        it 'raises an error' do
          expect { MessageTemplate.formatted_text(sender, consult, 'Hello') }.to raise_error(RuntimeError)
        end
      end

      context 'sender first name is missing' do
        before do
          sender.stub(:first_name) { '' }
        end

        it 'raises an error' do
          expect { MessageTemplate.formatted_text(sender, consult, 'Hello') }.to raise_error(RuntimeError)
        end
      end
    end

    it 'raises an error when merge tags are not replaced' do
      expect { MessageTemplate.formatted_text(sender, consult, 'Hello *|member_first_name|*, I am *|sender_first_name|*. You *|test|*') }.to raise_error(RuntimeError)
    end
  end
end

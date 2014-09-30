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
  it_validates 'foreign key of', :content

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
        MessageTemplate.should_receive(:formatted_text).with(sender, consult.initiator, message_template.text) { 'Test' }
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
        expect(scheduled_message.recipient).to eq(consult.initiator)
        expect(scheduled_message.publish_at).to eq(publish_at)
        expect(scheduled_message.text).to eq(message_template.text)
      end
    end

    describe '#create_scheduled_plain_text_email' do
      it 'schedules a message' do
        scheduled_email = message_template.create_scheduled_plain_text_email(sender,
                                                                             consult.initiator,
                                                                             publish_at)
        expect(scheduled_email).to be_persisted
        expect(scheduled_email.sender).to eq(sender)
        expect(scheduled_email.recipient).to eq(consult.initiator)
        expect(scheduled_email.publish_at).to eq(publish_at)
        expect(scheduled_email.text).to eq(message_template.text)
      end
    end
  end

  describe '#formatted_text' do
    let!(:sender) { build :pha, first_name: 'Kevin' }
    let!(:member) { build :member, :premium, pha: sender }
    let!(:consult) { build :consult, initiator: member, subject: member }
    let!(:nux_answer) { create :nux_answer }
    describe '*|member_first_name|*' do
      it 'replaces member_first_name' do
        expect(described_class.formatted_text(sender, consult.initiator, 'Hello *|member_first_name|*')).to eq("Hello #{consult.initiator.salutation}")
      end

      it 'raises an error if the salutation is not present' do
        consult.initiator.stub(salutation: nil)
        expect{ described_class.formatted_text(sender, consult.initiator, 'Hello *|member_first_name|*') }.to raise_error(RuntimeError)
      end
    end

    describe '*|sender_first_name|*' do
      it 'replaces sender_first_name' do
        expect(described_class.formatted_text(sender, consult.initiator, 'I am *|sender_first_name|*.')).to eq('I am Kevin.')
      end

      it 'raises an error if the sender first name is not present' do
        sender.update_attributes(first_name: '')
        expect{ described_class.formatted_text(sender, consult.initiator, 'Hello *|sender_first_name|*') }.to raise_error(RuntimeError)
      end
    end

    describe '*|pha_first_name|*' do
      it 'replaces pha_first_name' do
        expect(described_class.formatted_text(sender, consult.initiator, 'Hello *|pha_first_name|*')).to eq("Hello #{sender.first_name}")
      end

      it 'raises an error if the salutation is not present' do
        sender.update_attributes(first_name: '')
        expect{ described_class.formatted_text(sender, consult.initiator, 'Hello *|pha_first_name|*') }.to raise_error(RuntimeError)
      end
    end

    describe '*|nux_answer|*' do
      it 'replaces nux answer' do
        member.update_attributes nux_answer: nux_answer
        described_class.formatted_text(sender, consult.initiator, 'You need help with *|nux_answer|*').should == "You need help with #{nux_answer.phrase}"
      end

      it 'uses the default nux answer if it\'s not present' do
        NuxAnswer.stub(:find_by_name).with('something else') { nux_answer }
        member.update_attributes nux_answer: nil
        described_class.formatted_text(sender, consult.initiator, 'You need help with *|nux_answer|*').should == "You need help with #{nux_answer.phrase}"
      end

      it 'raises an error if the nux answer is not present' do
        member.update_attributes nux_answer: nil
        expect{ described_class.formatted_text(sender, consult.initiator, 'Hello *|nux_answer|*') }.to raise_error(RuntimeError)
      end
    end

    describe '*|pha_next_available|*' do
      before do
        Timecop.freeze(Time.parse("December 23, 2010 22:00 PST -08:00"))
      end

      after do
        Timecop.return()
      end

      it 'replaces pha_next_available' do
        member.update_attributes!(time_zone: 'America/New_York')
        described_class.formatted_text(sender, consult.initiator, 'Your pha is available *|pha_next_available|*').should == "Your pha is available today at 12PM"
      end
    end

    describe 'discrete variables' do
      it 'replaces any text with a variable key' do
        expect(described_class.formatted_text(sender, consult.initiator, 'foo *|bar|*', {'bar' => 'baz'})).to eq('foo baz')
      end
    end

    it 'raises an error when merge tags are not replaced' do
      expect{ MessageTemplate.formatted_text(sender, consult.initiator, 'Hello *|member_first_name|*, I am *|sender_first_name|*. You *|test|*') }.to raise_error(RuntimeError)
    end
  end
end

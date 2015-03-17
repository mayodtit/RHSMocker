require 'spec_helper'

describe PubSub do
  describe '#message' do
    context 'phone number exists' do
      context 'production' do
        before do
          Rails.env.stub(:production?) { true }
        end

        it 'sends the body and uses PHA phone number' do
          TwilioModule.client.account.messages.should_receive(:create).with(
            from: PhoneNumberUtil::format_for_dialing(Metadata.outbound_calls_number),
            to: PhoneNumberUtil::format_for_dialing('4083913578'),
            body: 'Hello'
          )
          TwilioModule.message_without_delay '4083913578', 'Hello'
        end
      end

      context 'not production' do
        it 'prepends the environment to body' do
          TwilioModule.client.account.messages.should_receive(:create).with(
            from: PhoneNumberUtil::format_for_dialing(SERVICE_ALERT_PHONE_NUMBER),
            to: PhoneNumberUtil::format_for_dialing('4083913578'),
            body: 'test - Hello'
          )
          TwilioModule.message_without_delay '4083913578', 'Hello'
        end
      end
    end

    context 'phone number doesn\'t exist' do
      it 'does nothing' do
        TwilioModule.client.account.messages.should_not_receive :create
        TwilioModule.message_without_delay nil, 'Hello'
      end
    end
  end
end

require 'spec_helper'

describe 'SmsNotifications' do
  describe 'POST /api/v1/users/:user_id/addresses' do
    def do_request(params={})
      post "/api/v1/sms_notifications/download", params
    end

    let('phone_number') { '4155551212' }

    it 'queues an SMS to be sent' do
      TwilioModule.should_receive(:message).and_call_original
      expect{ do_request(phone_number: phone_number) }.to change(Delayed::Job, :count).by(1)
      expect(response).to be_success
    end
  end
end

require 'spec_helper'

describe 'Messages' do
  let(:user) { create(:member) }
  let(:consult) { create(:consult, initiator: user) }

  context 'existing record' do
    let!(:message) { create(:message, consult: consult) }

    describe 'GET /api/v1/consults/:consult_id/messages' do
      def do_request
        get "/api/v1/consults/#{consult.id}/messages", auth_token: user.auth_token
      end

      it 'indexes messages for the consult' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:messages].to_json).to eq([message].serializer.as_json.to_json)
      end
    end
  end

  describe 'POST /api/v1/consults/:consult_id/messages' do
    def do_request(params={})
      post "/api/v1/consults/#{consult.id}/messages", params.merge!(auth_token: user.auth_token)
    end

    let(:message_params) { {message: {text: 'test message'}} }

    it 'create a new message for the consult' do
      expect{ do_request(message_params) }.to change(Message, :count).by(2) # TODO - creates 2 messages including auto-response
      expect(response).to be_success
      body = JSON.parse(response.body, symbolize_names: true)
      message = Message.find(body[:message][:id])
      expect(body[:message].to_json).to eq(message.serializer.as_json.to_json)
    end
  end
end

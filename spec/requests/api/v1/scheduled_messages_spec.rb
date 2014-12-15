require 'spec_helper'

describe 'ScheduledMessages' do
  before do
    Timecop.freeze(Date.today.to_time)
  end

  after do
    Timecop.return
  end

  let!(:user) { create(:member) }
  let(:consult) { user.master_consult }
  let(:pha) { create(:pha) }
  let(:session) { pha.sessions.create }

  context 'existing record' do
    let!(:scheduled_message) { create(:scheduled_message, sender: pha, recipient: consult.initiator) }

    describe 'GET /api/v1/consults/:consult_id/scheduled_messages' do
      def do_request
        get "/api/v1/consults/#{consult.id}/scheduled_messages", auth_token: session.auth_token
      end

      it 'indexes scheduled_messages' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:scheduled_messages].to_json).to eq([scheduled_message].serializer.as_json.to_json)
      end
    end

    describe 'GET /api/v1/consults/:consult_id/scheduled_messages/:id' do
      def do_request
        get "/api/v1/consults/#{consult.id}/scheduled_messages/#{scheduled_message.id}", auth_token: session.auth_token
      end

      it 'shows the scheduled_message' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:scheduled_message].to_json).to eq(scheduled_message.serializer.as_json.to_json)
      end
    end

    describe 'PUT /api/v1/consults/:consult_id/scheduled_messages/:id' do
      def do_request(params={})
        put "/api/v1/consults/#{consult.id}/scheduled_messages/#{scheduled_message.id}", params.merge!(auth_token: session.auth_token)
      end

      let(:new_publish_at) { Time.now + 5.days }

      it 'updates the scheduled_message' do
        do_request(scheduled_message: {publish_at: new_publish_at})
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(scheduled_message.reload.publish_at).to eq(new_publish_at)
        expect(body[:scheduled_message].to_json).to eq(scheduled_message.serializer.as_json.to_json)
      end
    end

    describe 'DELETE /api/v1/consults/:consult_id/scheduled_messages/:id' do
      def do_request
        delete "/api/v1/consults/#{consult.id}/scheduled_messages/#{scheduled_message.id}", auth_token: session.auth_token
      end

      it 'destroys the scheduled_message' do
        do_request
        expect(response).to be_success
        expect(ScheduledMessage.find_by_id(scheduled_message.id)).to be_nil
      end
    end
  end

  describe 'POST /api/v1/consults/:consult_id/scheduled_messages' do
    def do_request(params={})
      post "/api/v1/consults/#{consult.id}/scheduled_messages", params.merge!(auth_token: session.auth_token)
    end

    let(:scheduled_message_attributes) { {text: 'hello world', publish_at: Time.now + 1.day} }

    it 'creates a scheduled_message' do
      expect{ do_request(scheduled_message: scheduled_message_attributes) }.to change(ScheduledMessage, :count).by(1)
      expect(response).to be_success
      body = JSON.parse(response.body, symbolize_names: true)
      expect(body[:scheduled_message][:text]).to eq(scheduled_message_attributes[:text])
    end
  end
end

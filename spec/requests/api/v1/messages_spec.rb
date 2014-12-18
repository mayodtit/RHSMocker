require 'spec_helper'

describe 'Messages' do
  let(:user) { create(:member) }
  let(:session) { user.sessions.create }
  let(:consult) { create(:consult, initiator: user) }

  before do
    Timecop.freeze(Time.new(2014, 4, 17, 12, 0, 0, '-07:00'))
    Metadata.create!(mkey: 'remove_robot_response', mvalue: 'true')
  end

  after do
    Timecop.return
  end

  context 'existing record' do
    let!(:message) { create(:message, consult: consult) }

    describe 'GET /api/v1/consults/:consult_id/messages' do
      def do_request
        get "/api/v1/consults/#{consult.id}/messages", auth_token: session.auth_token
      end

      it 'indexes messages for the consult' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:messages].to_json).to eq([message].serializer(shallow: true).as_json.to_json)
      end
    end

    describe 'GET /api/v1/consults/current/messages' do
      def do_request
        get '/api/v1/consults/current/messages', auth_token: session.auth_token
      end

      let!(:master_message) { create(:message, consult: user.master_consult) }

      it "indexes messages for the users's master consult" do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:messages].to_json).to eq([master_message].serializer(shallow: true).as_json.to_json)
      end
    end

    context 'consult has notes' do
      let!(:note) { create :message, consult: consult, note: true }

      context 'user is a pha' do
        let(:pha) { create(:pha) }
        let(:session) { pha.sessions.create }

        def do_request
          get "/api/v1/consults/#{consult.id}/messages", auth_token: session.auth_token
        end

        it 'indexes all messages for the consult' do
          do_request
          expect(response).to be_success
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:messages].to_json).to eq([message, note].serializer(shallow: true).as_json.to_json)
        end
      end

      context 'user is not a pha' do
        def do_request
          get "/api/v1/consults/#{consult.id}/messages", auth_token: session.auth_token
        end

        it 'indexes messages for the consult' do
          do_request
          expect(response).to be_success
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:messages].to_json).to eq([message].serializer(shallow: true).as_json.to_json)
        end
      end
    end

    context 'messages api allows pagination' do
      before do
        create_list(:message, 30, consult: consult)
      end

      describe 'GET /api/v1/consults/:consult_id/messages?page=1' do
        def do_request
          get "/api/v1/consults/#{consult.id}/messages?page=1", auth_token: session.auth_token
        end

        it 'indexes 25 messages for the user‘s master consult' do
          do_request
          expect(response).to be_success
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:messages].count).to eq(25)
        end
      end
    end
  end

  describe 'POST /api/v1/consults/:consult_id/messages' do
    def do_request(params={})
      post "/api/v1/consults/#{consult.id}/messages", params.merge!(auth_token: session.auth_token)
    end

    let(:message_params) { {message: {text: 'test message'}} }

    it 'create a new message for the consult' do
      expect{ do_request(message_params) }.to change(Message, :count).by(1)
      expect(response).to be_success
      body = JSON.parse(response.body, symbolize_names: true)
      message = Message.find(body[:message][:id])
      expect(body[:message].to_json).to eq(message.serializer.as_json.to_json)
    end
  end

  describe 'POST /api/v1/consults/current/messages' do
    def do_request(params={})
      post '/api/v1/consults/current/messages', params.merge!(auth_token: session.auth_token)
    end

    let(:message_params) { {message: {text: 'test message'}} }

    it 'create a new message for the consult' do
      expect{ do_request(message_params) }.to change(Message, :count).by(1)
      expect(response).to be_success
      body = JSON.parse(response.body, symbolize_names: true)
      message = Message.find(body[:message][:id])
      expect(body[:message].to_json).to eq(message.serializer.as_json.to_json)
    end
  end
end

require 'spec_helper'

describe 'Messages' do
  let(:user) { create(:member) }
  let(:session) { user.sessions.create }
  let(:consult) { create(:consult, initiator: user) }
  let(:total_count_for_pha) { consult.messages_and_notes.count }
  let(:total_count_for_user) { consult.messages.count }

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
        expect(body[:total_count]).to eq(total_count_for_pha)
        expect(body[:messaging_tutorial]).to eq({text: "Tell us how we can help you by sending a message to a Personal Health Assistant."})
      end

      context 'user has sent a message' do
        let!(:user_message) { create(:message, user: user, consult: user.master_consult) }

        it 'does not return messaging_tutorial' do
          do_request
          expect(response).to be_success
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:messages].to_json).to eq([message].serializer(shallow: true).as_json.to_json)
          expect(body[:total_count]).to eq(total_count_for_pha)
          expect(body[:messaging_tutorial]).to be_nil
        end
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
        expect(body[:total_count]).to eq(total_count_for_pha)
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
          expect(body[:total_count]).to eq(total_count_for_pha)
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
          expect(body[:total_count]).to eq(total_count_for_user)
        end
      end
    end

    context 'messages api allows pagination' do
      describe 'GET /api/v1/consults/:consult_id/messages?page=1' do
        def do_request
          get "/api/v1/consults/#{consult.id}/messages?page=1&per=5", auth_token: session.auth_token
        end

        before do
          create_list(:message, 6, consult: consult)
        end

        it 'indexes 5 messages for the user‘s master consult' do
          do_request
          expect(response).to be_success
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:messages].count).to eq(5)
          expect(body[:total_count]).to eq(total_count_for_pha)
        end
      end

      describe 'GET /api/v1/consults/:consult_id/messages?page=1&per=3' do
        let!(:first_message) { create(:message, consult: consult) }
        let!(:second_message) { create(:message, consult: consult) }
        let!(:third_message) { create(:message, consult: consult) }
        let!(:fourth_message) { create(:message, consult: consult) }

        def do_request
          get "/api/v1/consults/#{consult.id}/messages?page=1&per=3", auth_token: session.auth_token
        end

        it 'tests messaging pagination with page and page size specified' do
          do_request
          expect(response).to be_success
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:messages].map {|i| i[:id]}).to include(second_message.id, third_message.id, fourth_message.id)
          expect(body[:total_count]).to eq(total_count_for_pha)
        end
      end

      describe 'GET /api/v1/consults/:consult_id/messages?page=2&per=3' do
        let!(:first_message) { create(:message, consult: consult) }
        let!(:second_message) { create(:message, consult: consult) }
        let!(:third_message) { create(:message, consult: consult) }
        let!(:fourth_message) { create(:message, consult: consult) }
        let!(:fifth_message) { create(:message, consult: consult) }

        def do_request
          get "/api/v1/consults/#{consult.id}/messages?page=2&per=3", auth_token: session.auth_token
        end

        it 'tests messaging pagination at end of created terms' do
          do_request
          expect(response).to be_success
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:messages].map {|i| i[:id]}).to include(first_message.id, second_message.id)
          expect(body[:messages].map {|i| i[:id]}).not_to include(third_message.id, fourth_message.id, fifth_message.id)
          expect(body[:total_count]).to eq(total_count_for_pha)
        end
      end

      describe 'GET /api/v1/consults/:consult_id/messages?page=1&per=5&exclude[]=5&exclude[]=3' do
        let!(:first_message) { create(:message, consult: consult) }
        let!(:second_message) { create(:message, consult: consult) }
        let!(:third_message) { create(:message, consult: consult) }
        let!(:fourth_message) { create(:message, consult: consult) }
        let!(:fifth_message) { create(:message, consult: consult) }
        let!(:sixth_message) { create(:message, consult: consult) }
        let!(:seventh_message) { create(:message, consult: consult) }

        def do_request
          get "/api/v1/consults/#{consult.id}/messages?page=1&per=5&exclude[]=#{fifth_message.id}&exclude[]=#{third_message.id}", auth_token: session.auth_token
        end

        it 'tests messaging pagination with page, page size, and exclude parameters specified' do
          do_request
          expect(response).to be_success
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:messages].map {|i| i[:id]}).to include(seventh_message.id, sixth_message.id, fourth_message.id)
          expect(body[:messages].map {|i| i[:id]}).not_to include(fifth_message.id, third_message.id)
          expect(body[:messages].size).to eql(3)
          expect(body[:total_count]).to eq(total_count_for_pha)
        end
      end

      describe 'GET /api/v1/consults/:consult_id/messages?page=1&per=5&exclude[]=5&exclude[]=3&before=7' do
        let!(:first_message) { create(:message, consult: consult) }
        let!(:second_message) { create(:message, consult: consult) }
        let!(:third_message) { create(:message, consult: consult) }
        let!(:fourth_message) { create(:message, consult: consult) }
        let!(:fifth_message) { create(:message, consult: consult) }
        let!(:sixth_message) { create(:message, consult: consult) }
        let!(:seventh_message) { create(:message, consult: consult) }

        def do_request
          get "/api/v1/consults/#{consult.id}/messages?page=1&per=5&exclude[]=#{fifth_message.id}&exclude[]=#{third_message.id}&before=#{seventh_message.id}", auth_token: session.auth_token
        end

        it 'tests messaging pagination with page, page size, exclude, and before parameters specified' do
          do_request
          expect(response).to be_success
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:messages].map {|i| i[:id]}).to include(sixth_message.id, fourth_message.id, second_message.id)
          expect(body[:messages].map {|i| i[:id]}).not_to include(fifth_message.id, third_message.id)
          expect(body[:messages].size).to eql(3)
          expect(body[:total_count]).to eq(total_count_for_pha)
        end
      end

      describe 'GET /api/v1/consults/:consult_id/messages?page=1&per=5&exclude[]=5&exclude[]=3&after=2' do
        let!(:first_message) { create(:message, consult: consult) }
        let!(:second_message) { create(:message, consult: consult) }
        let!(:third_message) { create(:message, consult: consult) }
        let!(:fourth_message) { create(:message, consult: consult) }
        let!(:fifth_message) { create(:message, consult: consult) }
        let!(:sixth_message) { create(:message, consult: consult) }
        let!(:seventh_message) { create(:message, consult: consult) }

        def do_request
          get "/api/v1/consults/#{consult.id}/messages?page=1&per=5&exclude[]=#{fifth_message.id}&exclude[]=#{third_message.id}&after=#{second_message.id}", auth_token: session.auth_token
        end

        it 'tests messaging pagination with page, page size, exclude, and after parameters specified' do
          do_request
          expect(response).to be_success
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:messages].map {|i| i[:id]}).to include(fourth_message.id, sixth_message.id, seventh_message.id)
          expect(body[:messages].map {|i| i[:id]}).not_to include(fifth_message.id, third_message.id)
          expect(body[:messages].size).to eql(3)
          expect(body[:total_count]).to eq(total_count_for_pha)
        end
      end

      describe 'GET /api/v1/consults/:consult_id/messages?page=1&per=5&before=5&after=2' do
        let!(:first_message) { create(:message, consult: consult) }
        let!(:second_message) { create(:message, consult: consult) }
        let!(:third_message) { create(:message, consult: consult) }
        let!(:fourth_message) { create(:message, consult: consult) }
        let!(:fifth_message) { create(:message, consult: consult) }
        let!(:sixth_message) { create(:message, consult: consult) }
        let!(:seventh_message) { create(:message, consult: consult) }

        def do_request
          get "/api/v1/consults/#{consult.id}/messages?page=1&per=5&before=#{fifth_message.id}&after=#{second_message.id}", auth_token: session.auth_token
        end

        it 'tests messaging pagination with page, page size, before, and after parameters specified' do
          do_request
          expect(response).to be_success
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:messages].map {|i| i[:id]}).to include(third_message.id, fourth_message.id)
          expect(body[:messages].size).to eql(2)
          expect(body[:total_count]).to eq(total_count_for_pha)
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

    context 'with erroneous markdown' do
      describe 'space before' do
        let(:text) { "[Bad markdown link]( www.google.com)" }
        let(:message_params) { {message: {text: text}} }

        it 'corrects markdown before it saves' do
          expect{ do_request(message_params) }.to change(Message, :count).by(1)
          expect(response).to be_success
          body = JSON.parse(response.body, symbolize_names: true)
          message = Message.find(body[:message][:id])
          expect(body[:message].to_json).to eq(message.serializer.as_json.to_json)
          expect(message.text).to eq("[Bad markdown link](www.google.com)")
        end
      end

      describe 'space after' do
        let(:text) { "[Bad markdown link](www.google.com )" }
        let(:message_params) { {message: {text: text}} }

        it 'corrects markdown before it saves' do
          expect{ do_request(message_params) }.to change(Message, :count).by(1)
          expect(response).to be_success
          body = JSON.parse(response.body, symbolize_names: true)
          message = Message.find(body[:message][:id])
          expect(body[:message].to_json).to eq(message.serializer.as_json.to_json)
          expect(message.text).to eq("[Bad markdown link](www.google.com)")
        end
      end

      describe 'space before and after' do
        let(:text) { "[Bad markdown link]( www.google.com )" }
        let(:message_params) { {message: {text: text}} }

        it 'corrects markdown before it saves' do
          expect{ do_request(message_params) }.to change(Message, :count).by(1)
          expect(response).to be_success
          body = JSON.parse(response.body, symbolize_names: true)
          message = Message.find(body[:message][:id])
          expect(body[:message].to_json).to eq(message.serializer.as_json.to_json)
          expect(message.text).to eq("[Bad markdown link](www.google.com)")
        end
      end
    end
  end

  describe 'POST /api/v1/consults/:consult_id/messages' do
    def do_request(params={})
      post "/api/v1/consults/#{consult.id}/messages", params.merge!(auth_token: session.auth_token)
    end

    let!(:first_message) { create(:message, consult: consult) }
    let!(:second_message) { create(:message, consult: consult) }
    let(:message_params) { {:message=>{:text => "test message"}, :after=> first_message.id} }

    it 'create a new message for the consult' do
      expect{ do_request(message_params) }.to change(Message, :count).by(1)
      expect(response).to be_success
      body = JSON.parse(response.body, symbolize_names: true)
      message = Message.find(body[:message][:id])
      expect(body[:message].to_json).to eq(message.serializer.as_json.to_json)
      expect(body[:messages].map {|i| i[:id]}).to include(message.id, second_message.id)
      expect(body[:messages].size).to eql(2)
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

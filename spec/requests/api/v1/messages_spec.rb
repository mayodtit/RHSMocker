require 'spec_helper'

describe 'Messages' do
  let(:encounter) { create(:encounter, :with_messages) }
  let(:user) { encounter.users.first }
  let(:message) { encounter.messages.first }

  before(:each) do
    user.login
  end

  describe 'GET /api/v1/encounters/:encounter_id/messages' do
    def do_request
      get "/api/v1/encounters/#{encounter.id}/messages", auth_token: user.auth_token
    end

    it 'indexes messages for the encounter' do
      do_request
      response.should be_success
      body = JSON.parse(response.body, :symbolize_names => true)
      ids = body[:messages].map{|m| m[:id]}
      ids.should include(message.id)
    end
  end

  describe 'GET /api/v1/encounters/:encounter_id/messages/:id' do
    def do_request
      get "/api/v1/encounters/#{encounter.id}/messages/#{message.id}", auth_token: user.auth_token
    end

    it 'shows the message' do
      do_request
      response.should be_success
      body = JSON.parse(response.body, :symbolize_names => true)
      body[:message][:id].should == message.id
    end
  end

  describe 'POST /api/v1/encounters/:encounter_id/messages' do
    def do_request(params={})
      post "/api/v1/encounters/#{encounter.id}/messages", {auth_token: user.auth_token}.merge!(:message => params)
    end

    let(:message_params) { {:text => 'test message'} }

    it 'create a new message for the encounter' do
      lambda{ do_request(message_params) }.should change(Message, :count).by(1)
      response.should be_success
      body = JSON.parse(response.body, :symbolize_names => true)
      new_message = Message.find(body[:message][:id])
      encounter.reload.messages.should include(message, new_message)
      user.reload.messages.should include(new_message)
    end
  end
end

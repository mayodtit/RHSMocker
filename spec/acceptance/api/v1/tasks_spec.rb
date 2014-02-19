require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Tasks" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:user) { create(:pha) }
  let!(:phone_call_message) { create(:message, :with_phone_call) }
  let!(:scheduled_phone_call_message) { create(:message, :with_scheduled_phone_call) }
  let!(:unread_message) { create(:message, text: 'test message', image: 'http://test.com/meme.jpg') }
  let!(:another_unread_message) { create(:message, text: 'test message 2', image: 'http://test.com/meme2.jpg') }
  let!(:unread_message_same_consult) { create(:message, text: 'test message 2', image: 'http://test.com/meme2.jpg', consult: unread_message.consult) }
  let!(:read_message) { create(:message, text: 'another test message', unread_by_cp: false) }

  let(:auth_token) { user.auth_token }

  before(:each) do
    user.login
  end

  describe 'index' do
    parameter :auth_token, 'Performing user\'s auth_token'

    required_parameters :auth_token

    let(:auth_token) { user.auth_token }

    get '/api/v1/tasks' do
      example_request '[GET] Get all unread messages' do
        explanation 'Placeholder for retrieving all unread messages until we create a tasks model.'
        status.should == 200
        response = JSON.parse response_body, symbolize_names: true
        response[:tasks].to_json.should == [unread_message, another_unread_message].serializer.as_json.to_json
      end
    end
  end
end

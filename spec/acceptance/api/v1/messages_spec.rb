require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Messages" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:user) { create(:member) }
  let(:session) { user.sessions.create(device_app_version: '1.3.0') }
  let!(:consult) { create(:consult, initiator: user) }
  let(:auth_token) { session.auth_token }
  let(:consult_id) { consult.id }

  parameter :auth_token, "Performing user's auth_token"
  required_parameters :auth_token

  before do
    Metadata.create!(mkey: 'remove_robot_response', mvalue: 'true')
    CarrierWave::Mount::Mounter.any_instance.stub(:store!)
  end

  context 'existing record' do
    let!(:message) { create(:message, consult: consult) }
    let!(:old_message) { create(:message, consult: consult, created_at: Time.parse('2014-08-26T00:17:26Z')) }

    get '/api/v1/consults/:consult_id/messages' do
      parameter :last_message_date, 'DEPRECATED: Pull messages after this date'

      let(:last_message_date) { '2014-08-26T00:17:26Z' }

      example_request "[GET] Get all Messages for a given Consult" do
        explanation "Returns an array of Messages"
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:messages].to_json).to eq([message].serializer(shallow: true).as_json.to_json)
      end
    end
  end

  post '/api/v1/consults/:consult_id/messages' do
    parameter :text, 'Message text'
    parameter :content_id, 'ID of Content to link to Message'
    parameter :image, 'Base64-encoded image'
    parameter :user_image_client_guid, 'Client-generated unique identifier for associated UserImage'
    scope_parameters :message, [:text, :content_id, :image, :user_image_client_guid]

    let(:text) { 'text' }
    let(:content_id) { create(:content).id }
    let(:image) { base64_test_image }
    let(:raw_post) { params.to_json }

    example_request "[POST] Create a new Message for a given Consult" do
      explanation "Creates a new Message for a given Consult from the current user"
      expect(status).to eq(200)
      body = JSON.parse(response_body, symbolize_names: true)
      message = Message.find(body[:message][:id])
      expect(body[:message].to_json).to eq(message.serializer.as_json.to_json)
      expect(body[:message][:image_url]).to_not be_nil
    end
  end
end

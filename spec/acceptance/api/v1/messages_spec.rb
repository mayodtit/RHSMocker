require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Messages" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:user) { create(:member) }
  let!(:consult) { create(:consult, initiator: user) }
  let(:auth_token) { user.auth_token }
  let(:consult_id) { consult.id }

  parameter :auth_token, "Performing user's auth_token"
  required_parameters :auth_token

  context 'existing record' do
    let!(:message) { create(:message, consult: consult) }

    get '/api/v1/consults/:consult_id/messages' do
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
    scope_parameters :message, [:text, :content_id, :image]

    let(:text) { 'text' }
    let(:content_id) { create(:content).id }
    let(:image) { base64_test_image }
    let(:raw_post) { params.to_json }

    example_request "[POST] Create a new Message for a given Consult" do
      explanation "Creates a new Message for a given Consult from the current user"
      expect(status).to eq(200)
      body = JSON.parse(response_body, symbolize_names: true)
      message = Message.find(body[:message][:id])
      # Because message is loaded on the after_save that updates last_contact_at
      message.user.last_contact_at = nil
      expect(body[:message].to_json).to eq(message.serializer.as_json.to_json)
      expect(body[:message][:image_url]).to_not be_nil
    end
  end
end

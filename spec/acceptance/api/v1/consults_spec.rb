require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Consults" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:user) { create(:member) }
  let(:session) { user.sessions.create }
  let(:user_id) { user.id }
  let(:auth_token) { session.auth_token }

  parameter :auth_token, "Performing user's auth_token"
  required_parameters :auth_token

  before do
    @nurse = Role.find_or_create_by_name 'nurse'
  end

  describe 'existing record' do
    let(:consult) { user.master_consult }
    let(:id) { consult.id }

    get '/api/v1/consults' do
      example_request "[DEPRECATED] [GET] Get all consults for a given user" do
        explanation "Returns an array of consults"
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:consults].to_json).to eq([consult.reload].serializer.as_json.to_json)
      end
    end

    get '/api/v1/consults/current' do
      example_request "[GET] Get master consult for the current user" do
        explanation 'Returns the master consult'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:consult].to_json).to eq(consult.reload.serializer.as_json.to_json)
      end
    end

    get '/api/v1/consults/:id' do
      example_request "[DEPRECATED] [GET] Get a consult for a given user" do
        explanation "Returns the given consult"
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:consult].to_json).to eq(consult.reload.serializer.as_json.to_json)
      end
    end
  end

  post '/api/v1/consults' do
    parameter :subject_id, 'ID of User that is the subject of consult'
    parameter :title, 'Title of the consult'
    parameter :description, 'Description of the consult'
    parameter :image, 'Base64-encoded image for the consult'
    parameter :message, 'Optional message to send with consult'
    parameter :phone_call, 'Optional phone_call to send with consult'
    parameter :scheduled_phone_call, 'Optional scheduled_phone_call to send with consult'
    required_parameters :title
    scope_parameters :consult, [:subject_id, :title, :description, :image,
                                :message, :phone_call, :scheduled_phone_call]

    let!(:scheduled) { create(:scheduled_phone_call, :assigned) }
    let(:subject_id) { user.id }
    let(:title) { 'title' }
    let(:description) { 'description' }
    let(:image) { base64_test_image }
    let(:message) { {text: 'message text'}}
    let(:phone_call) { {origin_phone_number: '5555555555',
                        destination_phone_number: '1234567890',
                        to_role: 'nurse'} }
    let(:scheduled_phone_call) { {callback_phone_number: '4083913578', scheduled_at: scheduled.scheduled_at} }
    let(:raw_post) { params.to_json }

    example_request '[POST] Create a Consult' do
      explanation 'Creates a new Consult'
      expect(status).to eq(200)
      body = JSON.parse(response_body, symbolize_names: true)
      consult = Consult.find(body[:consult][:id])
      expect(body[:consult].to_json).to eq(consult.serializer.as_json.to_json)
      consult.description.should == description
      PhoneCall.last.to_role.should == @nurse
    end
  end
end

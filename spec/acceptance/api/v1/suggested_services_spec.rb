require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'SuggestedService' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:user) { create(:member) }
  let(:session) { user.sessions.create }
  let(:user_id) { user.id }
  let(:auth_token) { session.auth_token }

  parameter :user_id, "ID of user for which to load, accepts 'current' to load current user's information"
  parameter :auth_token, 'User auth_token'
  required_parameters :auth_token

  post '/api/v1/users/:user_id/suggested_services' do
    parameter :title, 'Title of the suggested service'
    parameter :description, 'Description of the suggested service'
    parameter :service_type_id, 'Service type for the suggested service'
    scope_parameters :suggested_service, %i(title description service_type_id)

    let(:title) { 'title' }
    let(:description) { 'description' }
    let(:service_type) { create(:service_type) }
    let(:service_type_id) { service_type.id }
    let(:raw_post) { params.to_json }

    example_request '[POST] Create new SuggestedServices' do
      explanation 'Creates a new ad hoc SuggestedService and returns it'
      expect(status).to eq(200)
      body = JSON.parse(response_body, symbolize_names: true)
      new_suggested_service = SuggestedService.find(body[:suggested_service][:id])
      expect(body[:suggested_service].to_json).to eq(new_suggested_service.serializer.as_json.to_json)
    end
  end

  context 'existing record' do
    let!(:suggested_service) { create(:suggested_service, user: user) }

    get '/api/v1/users/:user_id/suggested_services' do
      example_request '[GET] Get all SuggestedServices' do
        explanation 'Returns an array of SuggestedServices'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:suggested_services].to_json).to eq([suggested_service].serializer(include_nested: true).as_json.to_json)
      end
    end

    get '/api/v1/users/:user_id/suggested_services/:id' do
      let(:id) { suggested_service.id }

      example_request '[GET] Get SuggestedService details' do
        explanation 'Returns the SuggestedService'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:suggested_service].to_json).to eq(suggested_service.serializer(include_nested: true).as_json.to_json)
      end
    end

    put '/api/v1/users/:user_id/suggested_services/:id' do
      parameter :state_event, 'State machine event to transition suggested service'
      parameter :user_facing, 'Whether the suggested service should be patient-facing (PHA only)'
      scope_parameters :suggested_service, %i(state_event user_facing)

      let(:state_event) { :offer }
      let(:id) { suggested_service.id }
      let(:raw_post) { params.to_json }

      example_request '[PUT] Get SuggestedService details' do
        explanation 'Returns the SuggestedService'
        expect(suggested_service).to be_unoffered
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:suggested_service].to_json).to eq(suggested_service.reload.serializer.as_json.to_json)
        expect(suggested_service).to_not be_unoffered
        expect(suggested_service).to be_offered
      end
    end
  end
end

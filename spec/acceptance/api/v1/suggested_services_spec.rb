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

  context 'existing record' do
    let!(:suggested_service) { create(:suggested_service, user: user) }

    get '/api/v1/users/:user_id/suggested_services' do
      example_request '[GET] Get all SuggestedServices' do
        explanation 'Returns an array of SuggestedServices'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:suggested_services].to_json).to eq([suggested_service].serializer.as_json.to_json)
      end
    end

    get '/api/v1/users/:user_id/suggested_services/:id' do
      let(:id) { suggested_service.id }

      example_request '[GET] Get SuggestedService details' do
        explanation 'Returns the SuggestedService'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:suggested_service].to_json).to eq(suggested_service.serializer.as_json.to_json)
      end
    end
  end
end

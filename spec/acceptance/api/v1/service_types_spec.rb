require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Service Types' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:user) { create :pha }
  let(:auth_token) { user.auth_token }
  let!(:service_b) { create :service_type, name: 'Service B' }
  let!(:service_a) { create :service_type, name: 'Service A '}

  describe 'index' do
    parameter :auth_token, "Performing user's auth_token"
    required_parameters :auth_token

    get '/api/v1/service_types' do
      example_request '[GET] Retreive all service types' do
        explanation 'Returns an array of service types'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:service_types].to_json).to eq([service_a, service_b].serializer.as_json.to_json)
      end
    end
  end
end

require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Service Types' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:user) { create :pha }
  let(:session) { user.sessions.create }
  let(:auth_token) { session.auth_token }
  let!(:service_b) { create :service_type, name: 'Service B', bucket: 'insurance' }
  let!(:service_a) { create :service_type, name: 'Service A', bucket: 'insurance' }
  let!(:service_c) { create :service_type, name: 'Service C', bucket: 'wellness' }

  describe 'index' do
    parameter :auth_token, "Performing user's auth_token"
    parameter :bucket, "Bucket to filter by"

    required_parameters :auth_token

    let(:bucket) { 'insurance' }

    get '/api/v1/service_types' do
      example_request '[GET] Retrieve all service types' do
        explanation 'Returns an array of service types'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:service_types].to_json).to eq([service_a, service_b].serializer.as_json.to_json)
      end
    end
  end

  describe 'buckets' do
    parameter :auth_token, "Performing user's auth_token"
    required_parameters :auth_token

    get '/api/v1/service_types/buckets' do
      example_request '[GET] Retreive all service buckets' do
        explanation 'Returns an array of service buckets'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:buckets].to_json).to eq(ServiceType::BUCKETS.as_json.to_json)
      end
    end
  end
end

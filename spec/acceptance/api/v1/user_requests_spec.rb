require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'UserRequest' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:user) { create(:member) }
  let(:user_id) { user.id }
  let(:auth_token) { user.auth_token }

  parameter :auth_token, 'User auth_token'
  required_parameters :auth_token

  context 'existing record' do
    let!(:user_request) { create(:user_request, user: user) }

    get '/api/v1/users/:user_id/user_requests' do
      example_request '[GET] Get all UserRequests' do
        explanation 'Returns an array of UserRequests'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:user_requests].to_json).to eq([user_request].serializer.as_json.to_json)
      end
    end

    get '/api/v1/users/:user_id/user_requests/:id' do
      let(:id) { user_request.id }

      example_request '[GET] Get UserRequest' do
        explanation 'Returns the UserRequest'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:user_request].to_json).to eq(user_request.serializer.as_json[:user_request].to_json)
      end
    end

    put '/api/v1/users/:user_id/user_requests/:id' do
      parameter :subject_id, 'Subject for the request'
      parameter :user_request_type_id, 'UserRequestType for the request'
      parameter :name, 'User facing name for the request'
      parameter :request_data, 'Hash of request attributes'
      scope_parameters :user_request, %i(subject_id name request_data)

      let(:name) { 'New request' }
      let(:request_data) { {client: :data} }
      let(:id) { user_request.id }
      let(:raw_post) { params.to_json }

      example_request '[PUT] Update UserRequest' do
        explanation 'Update the UserRequest'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:user_request][:name]).to eq(name)
      end
    end
  end

  post '/api/v1/users/:user_id/user_requests' do
    parameter :subject_id, 'Subject for the request'
    parameter :user_request_type_id, 'UserRequestType for the request'
    parameter :name, 'User facing name for the request'
    parameter :request_data, 'Hash of request attributes'
    required_parameters :subject_id, :user_request_type_id, :name
    scope_parameters :user_request, %i(subject_id name request_data)

    let(:subject_id) { user.id }
    let(:user_request_type_id) { create(:user_request_type).id }
    let(:name) { 'New request' }
    let(:request_data) { {client: :data} }
    let(:id) { user_request.id }
    let(:raw_post) { params.to_json }

    example_request '[POST] Create UserRequest' do
      explanation 'Create the UserRequest'
      expect(status).to eq(200)
      body = JSON.parse(response_body, symbolize_names: true)
      expect(body[:user_request][:name]).to eq(name)
    end
  end
end

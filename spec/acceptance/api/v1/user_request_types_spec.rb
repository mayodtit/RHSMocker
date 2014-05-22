require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'UserRequestTypes' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:user) { create(:member) }
  let(:auth_token) { user.auth_token }

  parameter :auth_token, 'User auth_token'
  required_parameters :auth_token

  context 'existing record' do
    let!(:user_request_type) { create(:user_request_type, :with_fields) }

    get '/api/v1/user_request_types' do
      example_request '[GET] Get all UserRequestTypes' do
        explanation 'Returns an array of UserRequestTypes'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:user_request_types].to_json).to eq([user_request_type].serializer.as_json.to_json)
      end
    end

    get '/api/v1/user_request_types/:id' do
      let(:id) { user_request_type.id }

      example_request '[GET] Get UserRequestType' do
        explanation 'Returns the UserRequestType'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:user_request_type].to_json).to eq(user_request_type.serializer.as_json.to_json)
      end
    end
  end
end

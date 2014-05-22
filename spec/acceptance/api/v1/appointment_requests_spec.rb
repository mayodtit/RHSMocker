require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'AppointmentRequests' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:user) { create(:member) }
  let(:user_id) { user.id }
  let(:auth_token) { user.auth_token }
  let!(:user_request_type) { create(:appointment_user_request_type) }

  parameter :auth_token, 'User auth_token'
  required_parameters :auth_token

  post '/api/v1/users/:user_id/appointment_requests' do
    parameter :subject_id, 'Subject for the request'
    parameter :name, 'User facing name for the request'
    required_parameters :subject_id, :name

    let(:subject_id) { user.id }
    let(:name) { 'New request' }
    let(:id) { user_request.id }
    let(:raw_post) { params.to_json }

    example_request '[POST] Create appointment UserRequest' do
      explanation 'Create an appointment UserRequest'
      expect(status).to eq(200)
      body = JSON.parse(response_body, symbolize_names: true)
      expect(body[:user_request][:name]).to eq(name)
    end
  end
end

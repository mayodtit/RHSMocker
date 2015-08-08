require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Contacts' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:user) { create(:member) }
  let(:session) { user.sessions.create }
  let(:auth_token) { session.auth_token }
  parameter :auth_token, 'User auth_token'
  required_parameters :auth_token

  get '/api/v1/contacts' do
    example_request '[GET] Contact list' do
      explanation 'Get all contacts for the current user'
      expect(status).to eq(200)
      body = JSON.parse(response_body, symbolize_names: true)
      expect(body[:contacts].class).to eq(Array)
      expect(body[:contacts].count).to eq(10)
    end
  end
end

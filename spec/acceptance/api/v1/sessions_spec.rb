 require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Sessions" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let(:password) { 'password' }
  let(:user) { create(:pha_lead) }
  let!(:member) { create(:member, password: password, pha_id: user.id) }

  post '/api/v1/login' do
    parameter :email, "User's email address"
    parameter :password, "User's password"
    required_parameters :email, :password

    let(:email) { member.email }
    let(:raw_post) { params.to_json }

    example_request '[POST] Sign in with email and password' do
      explanation 'returns the user and auth_token'
      expect(status).to eq(200)
      body = JSON.parse(response_body, symbolize_names: true)
      expect(member.sessions.count).to eq(1)
      expect(body[:auth_token]).to eq(member.sessions.first.auth_token)
      expect(body[:user].to_json).to eq(member.serializer(include_roles: true).as_json.to_json)
      expect(body[:pha].to_json).to eq(member.pha.serializer.as_json.to_json)
    end
  end

  delete '/api/v1/logout' do
    parameter :auth_token, "User's auth token"
    required_parameters :auth_token

    let!(:session) { member.sessions.create }
    let(:auth_token) { session.auth_token }
    let(:raw_post) { params.to_json }

    example_request "[DELETE] Sign out" do
      explanation "Signs out the user specified by the auth_token"
      expect(status).to eq(200)
      expect(Session.find_by_id(session.id)).to be_nil
    end
  end
end

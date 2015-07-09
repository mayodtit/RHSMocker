 require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Sessions" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let(:password) { 'password' }
  let(:user) { create(:pha_lead) }
  let!(:member) { create(:member, password: password, pha_id: user.id) }

  context "user is a pha and log in from care potal" do
    post '/api/v1/login' do
      parameter :email, "User's email address"
      parameter :password, "User's password"
      parameter :care_portal, "indicate user log in from care portal"
      required_parameters :email, :password, :care_portal

      let(:email) { user.email }
      let(:care_portal) {"yes"}
      let(:raw_post) { params.to_json }

      example_request '[POST] Sign in with email and password from care portal' do
        explanation 'returns the user and auth_token and set disabled at'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(user.care_portal_sessions.count).to eq(1)
        expect(user.care_portal_sessions.last.disabled_at).not_to eq(nil)
        expect(body[:auth_token]).to eq(user.care_portal_sessions.first.auth_token)
        expect(body[:user].to_json).to eq(user.serializer(include_roles: true).as_json.to_json)
      end
    end
  end

  context "user is log in from app" do
    post '/api/v1/login' do
      parameter :email, "User's email address"
      parameter :password, "User's password"
      required_parameters :email, :password

      let(:email) { member.email }
      let(:raw_post) { params.to_json }

      example_request '[POST] Sign in with email and password from app' do
        explanation 'returns the user and auth_token'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(member.sessions.count).to eq(1)
        expect(body[:auth_token]).to eq(member.sessions.first.auth_token)
        expect(body[:user].to_json).to eq(member.serializer(include_roles: true).as_json.to_json)
        expect(body[:pha].to_json).to eq(member.pha.serializer.as_json.to_json)
      end
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

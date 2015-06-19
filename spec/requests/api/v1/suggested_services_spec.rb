require 'spec_helper'

describe 'SuggestedServices' do
  let!(:user) { create(:member) }
  let!(:session) { user.sessions.create }

  context 'existing record' do
    let!(:suggested_service) { create(:suggested_service, user: user) }

    describe 'GET /api/v1/users/:user_id/suggested_services' do
      def do_request
        get "/api/v1/users/#{user.id}/suggested_services", auth_token: session.auth_token
      end

      it 'indexes suggested services' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:suggested_services].to_json).to eq([suggested_service].serializer.as_json.to_json)
      end
    end

    describe 'GET /api/v1/users/current/suggested_services' do
      def do_request
        get "/api/v1/users/current/suggested_services", auth_token: session.auth_token
      end

      it 'indexes suggested services for the current_user' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:suggested_services].to_json).to eq([suggested_service].serializer.as_json.to_json)
      end
    end

    describe 'GET /api/v1/users/:user_id/suggested_services/:id' do
      def do_request
        get "/api/v1/users/#{user.id}/suggested_services/#{suggested_service.id}", auth_token: session.auth_token
      end

      it 'shows the suggested service' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:suggested_service].to_json).to eq(suggested_service.serializer.as_json.to_json)
      end
    end

    describe 'GET /api/v1/users/current/suggested_services/:id' do
      def do_request
        get "/api/v1/users/current/suggested_services/#{suggested_service.id}", auth_token: session.auth_token
      end

      it 'shows the suggested service' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:suggested_service].to_json).to eq(suggested_service.serializer.as_json.to_json)
      end
    end
  end
end

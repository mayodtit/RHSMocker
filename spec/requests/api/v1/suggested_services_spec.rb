require 'spec_helper'

describe 'SuggestedServices' do
  let!(:user) { create(:member) }
  let!(:session) { user.sessions.create }

  describe 'POST /api/v1/users/:user_id/suggested_services' do
    def do_request(params={})
      post "/api/v1/users/#{user.id}/suggested_services", params.merge!(auth_token: session.auth_token)
    end

    let!(:service_type) { create(:service_type) }
    let!(:suggested_service_params) do
      attributes_for(:suggested_service).tap do |attrs|
        attrs[:service_type_id] = service_type.id
      end
    end

    it 'indexes suggested services' do
      expect{ do_request(suggested_service: suggested_service_params) }.to change(SuggestedService, :count).by(1)
      expect(response).to be_success
      body = JSON.parse(response.body, symbolize_names: true)
      new_suggested_service = SuggestedService.find(body[:suggested_service][:id])
      expect(body[:suggested_service].to_json).to eq(new_suggested_service.serializer.as_json.to_json)
    end
  end

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
        expect(body[:suggested_services].to_json).to eq([suggested_service].serializer(include_nested: true).as_json.to_json)
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
        expect(body[:suggested_services].to_json).to eq([suggested_service].serializer(include_nested: true).as_json.to_json)
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
        expect(body[:suggested_service].to_json).to eq(suggested_service.serializer(include_nested: true).as_json.to_json)
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
        expect(body[:suggested_service].to_json).to eq(suggested_service.serializer(include_nested: true).as_json.to_json)
      end
    end

    describe 'PUT /api/v1/users/:user_id/suggested_services/:id' do
      def do_request(params={})
        put "/api/v1/users/#{user.id}/suggested_services/#{suggested_service.id}", params.merge!(auth_token: session.auth_token)
      end

      it 'updates the suggested service' do
        expect(suggested_service).to be_unoffered
        do_request(suggested_service: {state_event: :offer})
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:suggested_service].to_json).to eq(suggested_service.reload.serializer.as_json.to_json)
        expect(suggested_service).to_not be_unoffered
        expect(suggested_service).to be_offered
      end
    end
  end
end

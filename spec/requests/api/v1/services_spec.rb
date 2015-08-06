require 'spec_helper'

describe 'Services' do
  let!(:pha) { create(:pha) }
  let!(:user) { create(:member, :premium, pha: pha) }
  let!(:session) { pha.sessions.create }

  describe 'POST /api/v1/users/:user_id/services' do
    def do_request(params={})
      post "/api/v1/users/#{user.id}/services", params.merge!(auth_token: session.auth_token)
    end

    let(:service_type) { create(:service_type) }
    let(:service_attributes) do
      {
        title: 'Title',
        service_type_id: service_type.id
      }
    end

    it 'creates a service' do
      expect{ do_request(service: service_attributes) }.to change(Service, :count).by(1)
      expect(response).to be_success
      body = JSON.parse(response.body, symbolize_names: true)
      service = Service.find(body[:service][:id])
      expect(body[:service].to_json).to eq(service.serializer.as_json.to_json)
    end
  end

  context 'existing record' do
    let!(:service) { create(:service, member: user, owner: pha) }

    describe '#index' do
      describe 'GET /api/v1/users/:user_id/services' do
        def do_request
          get "/api/v1/users/#{user.id}/services", auth_token: session.auth_token
        end

        it "indexes the user's services" do
          do_request
          expect(response).to be_success
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:services].to_json).to eq([service].serializer.as_json.to_json)
        end
      end

      describe 'GET /api/v1/members/:member_id/services' do
        def do_request
          get "/api/v1/members/#{user.id}/services", auth_token: session.auth_token
        end

        it "indexes the user's services" do
          do_request
          expect(response).to be_success
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:services].to_json).to eq([service].serializer.as_json.to_json)
        end
      end
    end

    describe '#show' do
      describe 'GET /api/v1/users/:user_id/services/:id' do
        def do_request
          get "/api/v1/users/#{user.id}/services/#{service.id}", auth_token: session.auth_token
        end

        it "shows the user's service" do
          do_request
          expect(response).to be_success
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:service].to_json).to eq(service.serializer.as_json.to_json)
        end
      end

      describe 'GET /api/v1/members/:member_id/services/:id' do
        def do_request
          get "/api/v1/members/#{user.id}/services/#{service.id}", auth_token: session.auth_token
        end

        it "shows the user's service" do
          do_request
          expect(response).to be_success
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:service].to_json).to eq(service.serializer.as_json.to_json)
        end
      end
    end

    describe '#update' do
      let(:new_title) { 'New title for service' }

      describe 'PUT /api/v1/users/:user_id/services/:id' do
        def do_request(params={})
          put "/api/v1/users/#{user.id}/services/#{service.id}", params.merge!(auth_token: session.auth_token)
        end

        it "updates the user's service" do
          do_request(service: {title: new_title})
          expect(response).to be_success
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:service].to_json).to eq(service.reload.serializer.as_json.to_json)
          expect(service.title).to eq(new_title)
        end
      end

      describe 'PUT /api/v1/members/:member_id/services/:id' do
        def do_request(params={})
          put "/api/v1/members/#{user.id}/services/#{service.id}", params.merge!(auth_token: session.auth_token)
        end

        it "updates the user's service" do
          do_request(service: {title: new_title})
          expect(response).to be_success
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:service].to_json).to eq(service.reload.serializer.as_json.to_json)
          expect(service.title).to eq(new_title)
        end
      end
    end
  end
end

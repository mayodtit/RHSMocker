require 'spec_helper'

describe 'UserRequests' do
  let(:user) { create(:member) }
  let(:session) { user.sessions.create }

  context 'existing record' do
    let!(:user_request) { create(:user_request, user: user) }

    describe 'GET /api/v1/users/:user_id/user_requests' do
      def do_request
        get "/api/v1/users/#{user.id}/user_requests", auth_token: session.auth_token
      end

      it 'indexes user_requests' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:user_requests].to_json).to eq([user_request].serializer(root: :user_requests).as_json[:user_requests].to_json)
      end
    end

    describe 'GET /api/v1/users/:user_id/user_requests/:id' do
      def do_request
        get "/api/v1/users/#{user.id}/user_requests/#{user_request.id}", auth_token: session.auth_token
      end

      it 'shows the user_request' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:user_request].to_json).to eq(user_request.serializer.as_json[:user_request].to_json)
      end
    end

    describe 'PUT /api/v1/users/:user_id/user_requests/:id' do
      def do_request(params={})
        put "/api/v1/users/#{user.id}/user_requests/#{user_request.id}", params.merge!(auth_token: session.auth_token)
      end

      let(:new_name) { 'new name' }

      it 'updates the user_request' do
        do_request(user_request: {name: new_name})
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(user_request.reload.name).to eq(new_name)
        expect(body[:user_request].to_json).to eq(user_request.serializer.as_json[:user_request].to_json)
      end
    end
  end

  describe 'POST /api/v1/users/:user_id/user_requests' do
    def do_request(params={})
      post "/api/v1/users/#{user.id}/user_requests", params.merge!(auth_token: session.auth_token)
    end

    let!(:user_request_type) { create(:user_request_type) }
    let(:user_request_attributes) { {name: 'new user request', subject_id: user.id, user_request_type_id: user_request_type.id} }

    it 'creates a user_request' do
      expect{ do_request(user_request: user_request_attributes) }.to change(UserRequest, :count).by(1)
      expect(response).to be_success
      body = JSON.parse(response.body, symbolize_names: true)
      expect(body[:user_request][:name]).to eq(user_request_attributes[:name])
    end
  end
end

require 'spec_helper'

describe 'UserRequestTypes' do
  let!(:user) { create(:admin) }

  context 'existing record' do
    let!(:user_request_type) { create(:user_request_type) }

    describe 'GET /api/v1/user_request_types' do
      def do_request
        get "/api/v1/user_request_types", auth_token: user.auth_token
      end

      it 'indexes user_request_types' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:user_request_types].to_json).to eq([user_request_type].serializer.as_json.to_json)
      end
    end

    describe 'GET /api/v1/user_request_types/:id' do
      def do_request
        get "/api/v1/user_request_types/#{user_request_type.id}", auth_token: user.auth_token
      end

      it 'shows the user_request_type' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:user_request_type].to_json).to eq(user_request_type.serializer.as_json.to_json)
      end
    end

    describe 'PUT /api/v1/user_request_types/:id' do
      def do_request(params={})
        put "/api/v1/user_request_types/#{user_request_type.id}", params.merge!(auth_token: user.auth_token)
      end

      let(:new_name) { 'New name' }

      it 'updates the user_request_type' do
        do_request(user_request_type: {name: new_name})
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(user_request_type.reload.name).to eq(new_name)
        expect(body[:user_request_type].to_json).to eq(user_request_type.serializer.as_json.to_json)
      end
    end
  end

  describe 'POST /api/v1/user_request_types' do
    def do_request(params={})
      post "/api/v1/user_request_types", params.merge!(auth_token: user.auth_token)
    end

    let!(:provider) { create(:member) }
    let(:user_request_type_attributes) { attributes_for(:user_request_type) }

    it 'creates a user_request_type' do
      expect{ do_request(user_request_type: user_request_type_attributes) }.to change(UserRequestType, :count).by(1)
      expect(response).to be_success
      body = JSON.parse(response.body, symbolize_names: true)
      expect(body[:user_request_type][:name]).to eq(user_request_type_attributes[:name])
    end
  end
end

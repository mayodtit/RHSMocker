require 'spec_helper'

describe 'UserImages' do
  let!(:user) { create(:member) }
  let(:session) { user.sessions.create }

  context 'existing record' do
    let!(:user_image) { create(:user_image, user: user) }

    describe 'GET /api/v1/users/:user_id/user_images' do
      def do_request
        get "/api/v1/users/#{user.id}/user_images", auth_token: session.auth_token
      end

      it 'indexes user_images' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:user_images].to_json).to eq([user_image].serializer.as_json.to_json)
      end
    end

    describe 'GET /api/v1/users/:user_id/user_images/:id' do
      def do_request
        get "/api/v1/users/#{user.id}/user_images/#{user_image.id}", auth_token: session.auth_token
      end

      it 'shows the user_image' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:user_image].to_json).to eq(user_image.serializer.as_json.to_json)
      end
    end

    describe 'PUT /api/v1/users/:user_id/user_images/:id' do
      def do_request(params={})
        put "/api/v1/users/#{user.id}/user_images/#{user_image.id}", params.merge!(auth_token: session.auth_token).to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
      end

      let(:new_image) { base64_test_image }

      it 'updates the user_image' do
        do_request(user_image: {image: new_image, client_guid: "GUID"})
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:user_image].to_json).to eq(user_image.reload.serializer.as_json.to_json)
      end
    end

    describe 'DELETE /api/v1/users/:user_id/user_images/:id' do
      def do_request
        delete "/api/v1/users/#{user.id}/user_images/#{user_image.id}", auth_token: session.auth_token
      end

      it 'destroys the user_image' do
        do_request
        expect(response).to be_success
        expect(UserImage.find_by_id(user_image.id)).to be_nil
      end
    end
  end


  describe 'POST /api/v1/users/:user_id/user_images' do
    def do_request(params={})
      post "/api/v1/users/#{user.id}/user_images", params.merge!(auth_token: session.auth_token).to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    end

    let(:image) { base64_test_image }
    let(:user_image_attributes) { { user_image: {image: image , client_guid: "GUID"}} }

    it 'creates a user_image' do
      expect{ do_request(user_image_attributes) }.to change(UserImage, :count).by(1)
      do_request(user_image_attributes)
      expect(response).to be_success
    end
  end
end

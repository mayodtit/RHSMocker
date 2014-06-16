require 'spec_helper'

describe 'Heights' do
  let!(:user) { create(:member) }

  context 'existing record' do
    let!(:height) { create(:height, user: user) }

    describe 'GET /api/v1/users/:user_id/heights' do
      def do_request
        get "/api/v1/users/#{user.id}/heights", auth_token: user.auth_token
      end

      it 'indexes heights' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:heights].to_json).to eq([height].serializer.as_json.to_json)
      end
    end

    describe 'GET /api/v1/users/:user_id/heights/:id' do
      def do_request
        get "/api/v1/users/#{user.id}/heights/#{height.id}", auth_token: user.auth_token
      end

      it 'shows the height' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:height].to_json).to eq(height.serializer.as_json.to_json)
      end
    end

    describe 'PUT /api/v1/users/:user_id/heights/:id' do
      def do_request(params={})
        put "/api/v1/users/#{user.id}/heights/#{height.id}", params.merge!(auth_token: user.auth_token)
      end

      let(:new_amount) { 145 }

      it 'updats the height' do
        do_request(height: {amount: new_amount})
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(height.reload.amount).to eq(new_amount)
        expect(body[:height].to_json).to eq(height.serializer.as_json.to_json)
      end
    end

    describe 'DELETE /api/v1/users/:user_id/heights/:id' do
      def do_request
        delete "/api/v1/users/#{user.id}/heights/#{height.id}", auth_token: user.auth_token
      end

      it 'destroys the height' do
        do_request
        expect(response).to be_success
        expect(Height.find_by_id(height.id)).to be_nil
      end
    end
  end

  describe 'POST /api/v1/users/:user_id/heights' do
    def do_request(params={})
      post "/api/v1/users/#{user.id}/heights", params.merge!(auth_token: user.auth_token)
    end

    let(:height_attributes) { attributes_for(:height) }

    it 'creats a height' do
      expect{ do_request(height: height_attributes) }.to change(Height, :count).by(1)
      expect(response).to be_success
      body = JSON.parse(response.body, symbolize_names: true)
      expect(body[:height][:height]).to eq(height_attributes[:height])
    end
  end
end

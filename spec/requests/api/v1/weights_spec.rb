require 'spec_helper'

describe 'Weights' do
  let!(:user) { create(:member) }
  let(:session) { user.sessions.create }

  context 'existing record' do
    let!(:weight) { create(:weight, user: user) }

    describe 'GET /api/v1/users/:user_id/weights' do
      def do_request
        get "/api/v1/users/#{user.id}/weights", auth_token: session.auth_token
      end

      it 'indexes weights' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:weights].to_json).to eq([weight].serializer.as_json.to_json)
      end
    end

    describe 'GET /api/v1/users/:user_id/weights/:id' do
      def do_request
        get "/api/v1/users/#{user.id}/weights/#{weight.id}", auth_token: session.auth_token
      end

      it 'shows the weight' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:weight].to_json).to eq(weight.serializer.as_json.to_json)
      end
    end

    describe 'PUT /api/v1/users/:user_id/weights/:id' do
      def do_request(params={})
        put "/api/v1/users/#{user.id}/weights/#{weight.id}", params.merge!(auth_token: session.auth_token)
      end

      let(:new_amount) { 145 }

      it 'updates the weight' do
        do_request(weight: {amount: new_amount})
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(weight.reload.amount.to_s).to eq(new_amount.to_f.to_s)
        expect(body[:weight].to_json).to eq(weight.serializer.as_json.to_json)
      end
    end

    describe 'DELETE /api/v1/users/:user_id/weights/:id' do
      def do_request
        delete "/api/v1/users/#{user.id}/weights/#{weight.id}", auth_token: session.auth_token
      end

      it 'destroys the weight' do
        do_request
        expect(response).to be_success
        expect(Weight.find_by_id(weight.id)).to be_nil
      end
    end
  end

  describe 'POST /api/v1/users/:user_id/weights' do
    def do_request(params={})
      post "/api/v1/users/#{user.id}/weights", params.merge!(auth_token: session.auth_token)
    end

    let(:weight_attributes) { attributes_for(:weight) }

    it 'creats a weight' do
      expect{ do_request(weight: weight_attributes) }.to change(Weight, :count).by(1)
      expect(response).to be_success
      body = JSON.parse(response.body, symbolize_names: true)
      expect(body[:weight][:amount]).to eq(weight_attributes[:amount].to_f.to_s)
    end
  end
end

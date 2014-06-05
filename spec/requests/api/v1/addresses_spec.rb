require 'spec_helper'

describe 'Addresses' do
  let!(:user) { create(:member) }

  context 'existing record' do
    let!(:address) { create(:address, user: user) }

    describe 'GET /api/v1/users/:user_id/addresses' do
      def do_request
        get "/api/v1/users/#{user.id}/addresses", auth_token: user.auth_token
      end

      it 'indexes addresses' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:addresses].to_json).to eq([address].serializer.as_json.to_json)
      end
    end

    describe 'GET /api/v1/users/:user_id/addresses/:id' do
      def do_request
        get "/api/v1/users/#{user.id}/addresses/#{address.id}", auth_token: user.auth_token
      end

      it 'shows the address' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:address].to_json).to eq(address.serializer.as_json.to_json)
      end
    end

    describe 'PUT /api/v1/users/:user_id/addresses/:id' do
      def do_request(params={})
        put "/api/v1/users/#{user.id}/addresses/#{address.id}", params.merge!(auth_token: user.auth_token)
      end

      let(:new_address) { '123 Test St.' }

      it 'updates the address' do
        do_request(address: {line1: new_address})
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(address.reload.address).to eq(new_address)
        expect(body[:address].to_json).to eq(address.serializer.as_json.to_json)
      end
    end

    describe 'DELETE /api/v1/users/:user_id/addresses/:id' do
      def do_request
        delete "/api/v1/users/#{user.id}/addresses/#{address.id}", auth_token: user.auth_token
      end

      it 'destroys the address' do
        do_request
        expect(response).to be_success
        expect(Address.find_by_id(address.id)).to be_nil
      end
    end
  end

  describe 'POST /api/v1/users/:user_id/addresses' do
    def do_request(params={})
      post "/api/v1/users/#{user.id}/addresses", params.merge!(auth_token: user.auth_token)
    end

    let(:address_attributes) { attributes_for(:address) }

    it 'creates a address' do
      expect{ do_request(address: address_attributes) }.to change(Address, :count).by(1)
      expect(response).to be_success
      body = JSON.parse(response.body, symbolize_names: true)
      expect(body[:address][:address]).to eq(address_attributes[:address])
    end
  end
end

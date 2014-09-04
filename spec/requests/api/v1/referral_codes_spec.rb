require 'spec_helper'

describe 'ReferralCodes' do
  let!(:user) { create(:admin) }
  let(:session) { user.sessions.create }

  context 'existing record' do
    let!(:referral_code) { create(:referral_code) }

    describe 'GET /api/v1/referral_codes' do
      def do_request
        get '/api/v1/referral_codes', auth_token: session.auth_token
      end

      it 'indexes referral_codes' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        ids = body[:referral_codes].map{|r| r[:id]}
        expect(ids).to include(referral_code.id)
      end
    end

    describe 'GET /api/v1/referral_codes/:id' do
      def do_request
        get "/api/v1/referral_codes/#{referral_code.id}", auth_token: session.auth_token
      end

      it 'shows the referral_code' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:referral_code].to_json).to eq(referral_code.serializer.as_json.to_json)
      end
    end

    describe 'PUT /api/v1/referral_codes/:id' do
      def do_request(params={})
        put "/api/v1/referral_codes/#{referral_code.id}", params.merge!(auth_token: session.auth_token)
      end

      let(:new_name) { 'new name' }

      it 'updates the referral_code' do
        do_request(referral_code: {name: new_name})
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(referral_code.reload.name).to eq(new_name)
        expect(body[:referral_code].to_json).to eq(referral_code.serializer.as_json.to_json)
      end
    end
  end

  describe 'POST /api/v1/referral_codes' do
    def do_request(params={})
      post '/api/v1/referral_codes', params.merge!(auth_token: session.auth_token)
    end

    let(:referral_code_attributes) { attributes_for(:referral_code) }

    it 'creates a referral_code' do
      expect{ do_request(referral_code: referral_code_attributes) }.to change(ReferralCode, :count).by(1)
      expect(response).to be_success
      body = JSON.parse(response.body, symbolize_names: true)
      expect(body[:referral_code][:name]).to eq(referral_code_attributes[:name])
    end
  end
end

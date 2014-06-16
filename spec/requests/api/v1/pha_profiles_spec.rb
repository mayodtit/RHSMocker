require 'spec_helper'

describe 'PhaProfiles' do
  let!(:user) { create(:pha_lead) }

  context 'existing record' do
    let!(:pha_profile) { create(:pha_profile, user: user) }

    describe 'GET /api/v1/pha_profiles' do
      def do_request
        get "/api/v1/pha_profiles", auth_token: user.auth_token
      end

      it 'indexes pha_profiles' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:pha_profiles].to_json).to eq([pha_profile].serializer.as_json.to_json)
      end
    end

    describe 'GET /api/v1/pha_profiles/:id' do
      def do_request
        get "/api/v1/pha_profiles/#{pha_profile.id}", auth_token: user.auth_token
      end

      it 'shows the pha_profile' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:pha_profile].to_json).to eq(pha_profile.serializer.as_json.to_json)
      end
    end

    describe 'PUT /api/v1/pha_profiles/:id' do
      def do_request(params={})
        put "/api/v1/pha_profiles/#{pha_profile.id}", params.merge!(auth_token: user.auth_token)
      end

      let(:new_weekly_capacity) { 1337 }

      it 'updats the pha_profile' do
        do_request(pha_profile: {weekly_capacity: new_weekly_capacity})
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(pha_profile.reload.weekly_capacity).to eq(new_weekly_capacity)
        expect(body[:pha_profile].to_json).to eq(pha_profile.serializer.as_json.to_json)
      end
    end
  end

  describe 'POST /api/v1/pha_profiles' do
    def do_request(params={})
      post "/api/v1/pha_profiles", params.merge!(auth_token: user.auth_token)
    end

    let(:pha_profile_attributes) { {user_id: user.id} }

    it 'creats a pha_profile' do
      expect{ do_request(pha_profile: pha_profile_attributes) }.to change(PhaProfile, :count).by(1)
      expect(response).to be_success
      body = JSON.parse(response.body, symbolize_names: true)
      expect(body[:pha_profile][:pha_profile]).to eq(pha_profile_attributes[:pha_profile])
    end
  end
end

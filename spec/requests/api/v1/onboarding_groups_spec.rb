require 'spec_helper'

describe 'OnboardingGroups' do
  let(:user) { create(:admin) }
  let(:session) { user.sessions.create }

  context 'existing record' do
    let!(:onboarding_group) { create(:onboarding_group) }

    describe 'GET /api/v1/onboarding_groups' do
      def do_request
        get '/api/v1/onboarding_groups', auth_token: session.auth_token
      end

      it 'indexes onboarding_groups' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:onboarding_groups].to_json).to eq([onboarding_group].serializer.as_json.each{|h| h[:users_count] = 0}.to_json)
      end
    end

    describe 'GET /api/v1/onboarding_groups/:id' do
      def do_request
        get "/api/v1/onboarding_groups/#{onboarding_group.id}", auth_token: session.auth_token
      end

      it 'shows the onboarding_group' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:onboarding_group].to_json).to eq(onboarding_group.serializer.as_json.to_json)
      end
    end

    describe 'PUT /api/v1/onboarding_groups/:id' do
      def do_request(params={})
        put "/api/v1/onboarding_groups/#{onboarding_group.id}", params.merge!(auth_token: session.auth_token)
      end

      let(:new_name) { 'new name' }

      it 'updates the onboarding_group' do
        do_request(onboarding_group: {name: new_name})
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(onboarding_group.reload.name).to eq(new_name)
        expect(body[:onboarding_group].to_json).to eq(onboarding_group.serializer.as_json.to_json)
      end
    end
  end

  describe 'POST /api/v1/onboarding_groups' do
    def do_request(params={})
      post '/api/v1/onboarding_groups', params.merge!(auth_token: session.auth_token)
    end

    let(:onboarding_group_attributes) { attributes_for(:onboarding_group) }

    it 'creates a onboarding_group' do
      expect{ do_request(onboarding_group: onboarding_group_attributes) }.to change(OnboardingGroup, :count).by(1)
      expect(response).to be_success
      body = JSON.parse(response.body, symbolize_names: true)
      expect(body[:onboarding_group][:name]).to eq(onboarding_group_attributes[:name])
    end
  end
end

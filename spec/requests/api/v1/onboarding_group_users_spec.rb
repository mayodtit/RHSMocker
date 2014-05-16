require 'spec_helper'

describe 'OnboardingGroupUsers' do
  let!(:user) { create(:admin) }
  let!(:onboarding_group) { create(:onboarding_group) }

  context 'existing record' do
    let!(:member) { onboarding_group.users.create(email: 'kyle@test.getbetter.com') }

    describe 'GET /api/v1/onboarding_groups/:onboarding_group_id/users' do
      def do_request
        get "/api/v1/onboarding_groups/#{onboarding_group.id}/users", auth_token: user.auth_token
      end

      it 'indexes onboarding_group users' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:users].to_json).to eq([member].as_json.to_json)
      end
    end

    describe 'DELETE /api/v1/onboarding_groups/:onboarding_group_id/users' do
      def do_request
        delete "/api/v1/onboarding_groups/#{onboarding_group.id}/users/#{member.id}", auth_token: user.auth_token
      end

      it 'unassigns the user onboarding_group' do
        do_request
        expect(response).to be_success
        expect(member.reload.onboarding_group).to be_nil
      end
    end
  end

  describe 'POST /api/v1/onboarding_groups/:onboarding_group_id/users' do
    def do_request(params={})
      post "/api/v1/onboarding_groups/#{onboarding_group.id}/users", params.merge!(auth_token: user.auth_token)
    end

    let(:user_attributes) { {email: 'new_test@test.getbetter.com'} }

    it 'creates a onboarding_group' do
      expect{ do_request(user: user_attributes) }.to change(Member, :count).by(1)
      expect(response).to be_success
      body = JSON.parse(response.body, symbolize_names: true)
      expect(body[:user][:email]).to eq(user_attributes[:email])
    end
  end
end

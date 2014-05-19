require 'spec_helper'

describe 'AdminMembers' do
  let!(:user) { create(:admin) }

  context 'existing record' do
    let!(:member) { create(:member) }

    describe 'GET /api/v1/admin/members' do
      def do_request
        get "/api/v1/admin/members", auth_token: user.auth_token
      end

      it 'indexes members' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        ids = body[:users].map{|u| u[:id]}
        expect(ids).to include(user.id, member.id)
      end
    end

    describe 'GET /api/v1/admin/members/:id' do
      def do_request
        get "/api/v1/admin/members/#{member.id}", auth_token: user.auth_token
      end

      it 'shows the member' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:user].to_json).to eq(member.serializer.as_json.to_json)
      end
    end

    describe 'PUT /api/v1/admin/members/:id' do
      def do_request(params={})
        put "/api/v1/admin/members/#{member.id}", params.merge!(auth_token: user.auth_token)
      end

      let(:new_is_premium) { true }

      it 'updates the onboarding_group' do
        do_request(user: {is_premium: new_is_premium})
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(member.reload.is_premium).to eq(new_is_premium)
        expect(body[:user].to_json).to eq(member.serializer.as_json.to_json)
      end
    end
  end
end

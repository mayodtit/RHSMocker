require 'spec_helper'

describe 'UserAgreements' do
  let!(:user) { create(:member) }
  let(:session) { user.sessions.create }
  let!(:agreement) { create(:agreement) }

  describe 'POST /api/v1/users/:user_id/agreements' do
    def do_request(params={})
      post "/api/v1/users/#{user.id}/agreements", params.merge!(auth_token: session.auth_token), {'HTTP_USER_AGENT' => 'test'}
    end

    let(:user_agreement_params) { {user_agreement: {agreement_id: agreement.id}} }

    it 'creates a new agreement for the user' do
      expect{ do_request(user_agreement_params) }.to change(UserAgreement, :count).by(1)
      expect(response).to be_success
      body = JSON.parse(response.body, symbolize_names: true)
      user_agreement = UserAgreement.find(body[:user_agreement][:id])
      expect(body[:user_agreement].to_json).to eq(user_agreement.as_json.to_json)
    end
  end
end

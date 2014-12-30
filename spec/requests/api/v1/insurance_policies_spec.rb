require 'spec_helper'

describe 'Insurance_Policies' do
  let!(:user) { create(:member) }
  let!(:session) { user.sessions.create }

  context 'existing record' do
    let!(:insurance_policy) { create(:insurance_policy, user: user) }

    describe 'GET /api/v1/users/:user_id/insurance_policies' do
      def do_request
        get "/api/v1/users/#{user.id}/insurance_policies", auth_token: session.auth_token
      end

      it 'indexes insurance_policies' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:insurance_policies].to_json).to eq([insurance_policy].serializer.as_json.to_json)
      end
    end

    describe 'GET /api/v1/users/:user_id/insurance_policies/:id' do
      def do_request
        get "/api/v1/users/#{user.id}/insurance_policies/#{insurance_policy.id}", auth_token: session.auth_token
      end

      it 'shows the insurance policy' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:insurance_policy].to_json).to eq(insurance_policy.serializer.as_json.to_json)
      end
    end

    describe 'PUT /api/v1/users/:user_id/insurance_policies/:id' do
      def do_request(params={})
        put "/api/v1/users/#{user.id}/insurance_policies/#{insurance_policy.id}", params.merge!(auth_token: session.auth_token)
      end

      let(:new_insurance_policy) { 'ABC Insurance Policy' }

      it 'updates the insurance policy' do
        do_request(insurance_policy: {company_name: new_insurance_policy})
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(insurance_policy.reload.company_name).to eq(new_insurance_policy)
        expect(body[:insurance_policy].to_json).to eq(insurance_policy.serializer.as_json.to_json)
      end
    end

    describe 'DELETE /api/v1/users/:user_id/insurance_policies/:id' do
      def do_request
        delete "/api/v1/users/#{user.id}/insurance_policies/#{insurance_policy.id}", auth_token: session.auth_token
      end

      it 'destroys the insurance policy' do
        do_request
        expect(response).to be_success
        expect(InsurancePolicy.unscoped.find_by_id(insurance_policy.id).disabled_at).to_not be_nil
      end
    end
  end

  describe 'POST /api/v1/users/:user_id/insurance_policies' do
    def do_request(params={})
      post "/api/v1/users/#{user.id}/insurance_policies", params.merge!(auth_token: session.auth_token)
    end

    let(:insurance_policy_attributes) { attributes_for(:insurance_policy) }

    it 'creates a insurance policy' do
      expect{ do_request(insurance_policy: insurance_policy_attributes) }.to change(InsurancePolicy, :count).by(1)
      expect(response).to be_success
      body = JSON.parse(response.body, symbolize_names: true)
      expect(body[:insurance_policy][:insurance_policy]).to eq(insurance_policy_attributes[:insurance_policy])
    end
  end
end

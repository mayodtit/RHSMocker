require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'InsurancePolicy' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:user) { create(:member) }
  let(:session) { user.sessions.create }
  let(:user_id) { user.id }
  let(:auth_token) { session.auth_token }

  parameter :auth_token, 'User auth_token'
  required_parameters :auth_token

  context 'existing record' do
    let!(:insurance_policy) { create(:insurance_policy, user: user) }

    get '/api/v1/users/:user_id/insurance_policies' do
      example_request '[GET] Get all Insurance Policies for a user' do
        explanation 'Returns an array of InsurancePolicies'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:insurance_policies].to_json).to eq([insurance_policy].serializer.as_json.to_json)
      end
    end

    get '/api/v1/users/:user_id/insurance_policies/:id' do
      let(:id) { insurance_policy.id }

      example_request '[GET] Get a single Insurance Policy' do
        explanation 'Returns the InsurancePolicy'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:insurance_policy].to_json).to eq(insurance_policy.serializer.as_json.to_json)
      end
    end

    put '/api/v1/users/:user_id/insurance_policies/:id' do
      parameter :company_name, 'Company name on Insurance Policy'
      parameter :plan_type, 'Insurance plan type'
      parameter :policy_member_id, 'Member ID for policy'
      scope_parameters :insurance_policy, [:company_name, :plan_type, :policy_member_id]

      let(:company_name) { 'Test Company' }
      let(:id) { insurance_policy.id }
      let(:raw_post) { params.to_json }

      example_request '[PUT] Update an InsurancePolicy' do
        explanation 'Update the InsurancePolicy'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:insurance_policy][:company_name]).to eq(company_name)
      end
    end

    delete '/api/v1/users/:user_id/insurance_policies/:id' do
      let(:id) { insurance_policy.id }
      let(:raw_post) { params.to_json }

      example_request '[DELETE] Destroy an Insurance Policy' do
        explanation 'Destroy an InsurancePolicy'
        expect(status).to eq(200)
      end
    end
  end

  post '/api/v1/users/:user_id/insurance_policies' do
    parameter :company_name, 'Company name on Insurance Policy'
    parameter :plan_type, 'Insurance plan type'
    parameter :policy_member_id, 'Member ID for policy'
    scope_parameters :insurance_policy, [:company_name, :plan_type, :policy_member_id]

    let(:company_name) { 'Test Company' }
    let(:raw_post) { params.to_json }

    example_request '[POST] Create a new Insurance Policy' do
      explanation 'Create the InsurancePolicy'
      expect(status).to eq(200)
      body = JSON.parse(response_body, symbolize_names: true)
      expect(body[:insurance_policy][:company_name]).to eq(company_name)
    end
  end
end

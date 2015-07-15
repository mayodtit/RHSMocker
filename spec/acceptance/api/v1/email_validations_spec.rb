require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Email Validations' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:onboarding_group) { create(:onboarding_group) }
  let!(:user) { create(:member, :premium, onboarding_group: onboarding_group) }

  get '/api/v1/email_validations' do
    parameter :email, "Email address to check"
    required_parameters :email

    let(:email) { user.email }

    example_request '[DEPRECATED] [GET] Check email address for onboarding' do
      explanation 'Check the email address'
      expect(status).to eq(200)
      body = JSON.parse(response_body, symbolize_names: true)
      expect(body[:requires_sign_up]).to be_false
      expect(body[:onboarding_group].to_json).to eq(onboarding_group.serializer(for_onboarding: true).as_json.to_json)
    end
  end
end

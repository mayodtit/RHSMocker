require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Onboarding' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  describe '#email_validation' do
    parameter :email, 'Email address to check'
    required_parameters :email

    let(:onboarding_group) { create(:onboarding_group, custom_welcome: 'Welcome to Better! This is a custom message just for you!', skip_credit_card: true) }
    let(:user) { create(:member, :premium, onboarding_group: onboarding_group) }
    let(:email) { user.email }

    # TODO - restore when at a later version of rspec_api_documenation
    # response_field :requires_sign_up, 'Whether the user needs to sign up or log in'
    # response_field :onboarding_customization, 'Customizations for sign up or log in screens; if this key is absent or value is null, do not apply any customization'
    # response_field :background_asset_url, 'Background customization for sign up or log in screen', scope: :onboarding_customization
    # response_field :header_asset_url, 'Header image customization for sign up or log in screen', scope: :onboarding_customization
    # response_field :onboarding_custom_welcome, 'Custom welcome screen; if this key is absent or value is null, do not show custom welcome'
    # response_field :background_asset_url, 'Background for custom welcome screen', scope: :onboarding_custom_welcome
    # response_field :header_asset_url, 'Header image for custom welcome screen', scope: :onboarding_custom_welcome
    # response_field :custom_welcome, 'Content for custom welcome screen', scope: :onboarding_custom_welcome

    get '/api/v1/onboarding/email_validation' do
      example_request '[GET] Validate email' do
        explanation 'Check for email existance and onboarding customization'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:requires_sign_up]).to be_false
        expect(body[:skip_credit_card]).to be_true
        expect(body[:onboarding_customization]).to eq(onboarding_group.serializer(onboarding_customization: true).as_json)
        expect(body[:onboarding_custom_welcome]).to eq([onboarding_group.serializer(onboarding_custom_welcome: true).as_json])
      end
    end
  end

  describe '#referral_code_validation' do
    parameter :code, 'Referral code to check'
    required_parameters :code

    let(:onboarding_group) { create(:onboarding_group, skip_credit_card: true, custom_welcome: 'Welcome to Better! This is a custom message just for you!') }
    let(:referral_code) { create(:referral_code, onboarding_group: onboarding_group) }
    let(:code) { referral_code.code }

    get '/api/v1/onboarding/referral_code_validation' do
      example_request '[GET] Validate referral code' do
        explanation 'Check validity of referral code and what screen to show next'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:skip_credit_card]).to be_true
        expect(body[:onboarding_custom_welcome]).to eq([onboarding_group.serializer(onboarding_custom_welcome: true).as_json])
      end
    end
  end

  describe '#log_in' do
    parameter :email, 'User email address'
    parameter :password, 'User password'
    required_parameters :email, :password

    let(:email) { 'test@getbetter.com' }
    let(:password) { 'password' }
    let!(:onboarding_group) { create(:onboarding_group, custom_welcome: 'Welcome to Better! This is a custom message just for you!') }
    let!(:pha) { create(:pha) }
    let!(:user) { create(:member, :premium, email: email, password: password, onboarding_group: onboarding_group, pha: pha) }
    let(:raw_post) { params.to_json }

    post '/api/v1/onboarding/log_in' do
      example_request '[POST] Log In' do
        explanation 'Create a new session and log in'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:user].to_json).to eq(user.serializer(include_roles: true).as_json.to_json)
        expect(body[:pha].to_json).to eq(pha.serializer.as_json.to_json)
        expect(body[:auth_token]).to be_present
        expect(body[:onboarding_custom_welcome]).to eq([onboarding_group.serializer(onboarding_custom_welcome: true).as_json])
      end
    end
  end
end
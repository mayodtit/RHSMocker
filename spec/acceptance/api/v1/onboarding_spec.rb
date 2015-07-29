require 'spec_helper'
require 'stripe_mock'
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

    before do
      CarrierWave::Mount::Mounter.any_instance.stub(:store!)
      onboarding_group.update_attributes!(header_asset: File.new(Rails.root.join('spec','support','kbcat.jpg')),
                                          background_asset: File.new(Rails.root.join('spec','support','kbcat.jpg')))
    end

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
        reloaded_onboarding_group = OnboardingGroup.find(onboarding_group.id)
        expect(body[:requires_sign_up]).to be_false
        expect(body[:skip_credit_card]).to be_true
        expect(body[:onboarding_customization]).to eq(reloaded_onboarding_group.serializer(onboarding_customization: true).as_json)
        expect(body[:onboarding_custom_welcome]).to eq([reloaded_onboarding_group.serializer(onboarding_custom_welcome: true).as_json])
      end
    end
  end

  describe '#referral_code_validation' do
    parameter :code, 'Referral code to check'
    required_parameters :code

    let(:onboarding_group) { create(:onboarding_group, skip_credit_card: true, custom_welcome: 'Welcome to Better! This is a custom message just for you!') }
    let(:referral_code) { create(:referral_code, onboarding_group: onboarding_group) }
    let(:code) { referral_code.code }

    before do
      CarrierWave::Mount::Mounter.any_instance.stub(:store!)
      onboarding_group.update_attributes!(header_asset: File.new(Rails.root.join('spec','support','kbcat.jpg')),
                                          background_asset: File.new(Rails.root.join('spec','support','kbcat.jpg')))
    end

    get '/api/v1/onboarding/referral_code_validation' do
      example_request '[GET] Validate referral code' do
        explanation 'Check validity of referral code and what screen to show next'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        reloaded_onboarding_group = OnboardingGroup.find(onboarding_group.id)
        expect(body[:skip_credit_card]).to be_true
        expect(body[:onboarding_custom_welcome]).to eq([reloaded_onboarding_group.serializer(onboarding_custom_welcome: true).as_json])
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
    let!(:suggested_service) { create(:suggested_service, user: user) }
    let(:raw_post) { params.to_json }

    before do
      CarrierWave::Mount::Mounter.any_instance.stub(:store!)
      onboarding_group.update_attributes!(header_asset: File.new(Rails.root.join('spec','support','kbcat.jpg')),
                                          background_asset: File.new(Rails.root.join('spec','support','kbcat.jpg')))
    end

    post '/api/v1/onboarding/log_in' do
      example_request '[POST] Log In' do
        explanation 'Create a new session and log in'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        reloaded_onboarding_group = OnboardingGroup.find(onboarding_group.id)
        expect(body[:user].to_json).to eq(user.serializer(include_roles: true).as_json.to_json)
        expect(body[:pha].to_json).to eq(pha.serializer.as_json.to_json)
        expect(body[:auth_token]).to be_present
        expect(body[:onboarding_custom_welcome]).to eq([reloaded_onboarding_group.serializer(onboarding_custom_welcome: true).as_json])
        expect(body[:suggested_services].to_json).to eq([suggested_service.serializer.as_json].to_json)
      end
    end
  end

  describe '#sign_up' do
    header 'User-Agent', 'test'
    parameter :email, 'User email address'
    parameter :password, 'User password'
    parameter :agreement_id, 'TOS and Privacy Policy agreement_id'
    parameter :payment_token, 'Stripe credit card token'
    parameter :code, 'Referral code'
    parameter :first_name, 'First name'
    parameter :birth_date, 'User date of birth'
    required_parameters :email, :password, :agreement_id
    scope_parameters :user, %i(email password agreement_id payment_token code first_name birth_date)

    let!(:pha_profile) { create(:pha_profile) }
    let!(:agreement) { create(:agreement, :active) }
    let!(:onboarding_group) { create(:onboarding_group) }
    let!(:referral_code) { create(:referral_code, onboarding_group: onboarding_group, creator: nil) }
    let!(:onboarding_group_suggested_service_template) { create(:onboarding_group_suggested_service_template, onboarding_group: onboarding_group) }
    let(:stripe_helper) { StripeMock.create_test_helper }
    let(:plan_id) { 'bp20' }
    let(:email) { 'test+signup@getbetter.com' }
    let(:password) { 'password' }
    let(:agreement_id) { agreement.id }
    let(:payment_token) { stripe_helper.generate_card_token }
    let(:code) { referral_code.code }
    let(:first_name) { 'Kyle' }
    let(:birth_date) { Date.today - 30.years }
    let(:raw_post) { params.to_json }

    before do
      StripeMock.start
      Stripe::Plan.create(amount: 1999,
                          interval: :month,
                          name: 'Single Membership',
                          currency: :usd,
                          id: plan_id)
    end

    after do
      StripeMock.stop
    end

    post '/api/v1/onboarding/sign_up' do
      example_request '[POST] Sign Up' do
        explanation 'Create a new session and log in'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        user = Member.find(body[:user][:id])
        expect(body[:user].to_json).to eq(user.serializer.as_json.to_json)
        expect(body[:member].to_json).to eq(user.serializer.as_json.to_json)
        expect(body[:pha_profile].to_json).to eq(pha_profile.serializer.as_json.to_json)
        expect(body[:auth_token]).to be_present
        expect(body[:suggested_services]).to_not be_empty
        expect(body[:suggested_services].to_json).to eq(user.suggested_services.serializer.as_json.to_json)
      end
    end
  end
end

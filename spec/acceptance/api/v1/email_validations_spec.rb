require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Email Validations' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:onboarding_group) { create(:onboarding_group) }
  let!(:user) { create(:member, :premium, onboarding_group: onboarding_group) }

  before do
    CarrierWave::Mount::Mounter.any_instance.stub(:store!)
    onboarding_group.update_attributes!(header_asset: File.new(Rails.root.join('spec','support','kbcat.jpg')),
                                        background_asset: File.new(Rails.root.join('spec','support','kbcat.jpg')))
  end

  get '/api/v1/email_validations' do
    parameter :email, "Email address to check"
    required_parameters :email

    let(:email) { user.email }

    example_request '[DEPRECATED] [GET] Check email address for onboarding' do
      explanation 'Check the email address'
      expect(status).to eq(200)
      body = JSON.parse(response_body, symbolize_names: true)
      reloaded_onboarding_group = OnboardingGroup.find(onboarding_group.id)
      expect(body[:requires_sign_up]).to be_false
      expect(body[:onboarding_customization].to_json).to eq(reloaded_onboarding_group.serializer(onboarding_customization: true).as_json.to_json)
    end
  end
end

require 'spec_helper'

describe 'OnboardingGroupCandidates' do
  let!(:onboarding_group) { create(:onboarding_group) }

  describe '#create' do
    def do_request(params={})
      post "/api/v1/onboarding_groups/#{onboarding_group.id}/onboarding_group_candidates", params
    end

    let(:first_name) { 'kyle' }
    let(:phone) { '4155551212' }
    let(:email) { 'test@getbetter.com' }
    let(:user_params) do
      {
        first_name: first_name,
        phone: phone,
        email: email,
        surgery_date: '10-4-1986',
        surgery_time: '10am',
        notes: "blah"
      }
    end

    it 'creates a onboarding group candidate' do
      expect{ do_request(user: user_params) }.to change(OnboardingGroupCandidate, :count).by(1)
      expect(response).to be_success
      body = JSON.parse(response.body, symbolize_names: true)
      onboarding_group_candidate = OnboardingGroupCandidate.find(body[:onboarding_group_candidate][:id])
      expect(body[:onboarding_group_candidate]).to eq(onboarding_group_candidate.serializer.as_json)
    end
  end
end

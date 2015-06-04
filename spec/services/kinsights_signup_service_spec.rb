require 'spec_helper'

describe KinsightsSignupService do
  let(:user) { create(:member) }
  let(:token) { 'token' }
  let(:patient_url) { 'patient_url' }
  let(:profile_url) { 'profile_url' }

  before do
    stub_request(:get, "https://kinsights.com/records/careteam/delegate/token/accept/")
    .with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'kinsights.com', 'User-Agent'=>'Ruby'})
    .to_return(status: 200, body: {patient_url: patient_url, profile_url: profile_url}.to_json, headers: {})
  end

  describe '#call' do
    it 'posts a request to kinsights with the given token and sets local values' do
      expect(user.kinsights_patient_url).to be_nil
      expect(user.kinsights_profile_url).to be_nil
      NewKinsightsMemberTask.should_receive(:create).with(member: user.owner, subject: user)
      described_class.new(user, token).call
      expect(user.kinsights_patient_url).to eq(patient_url)
      expect(user.kinsights_profile_url).to eq(profile_url)

    end
  end
end

require 'spec_helper'

describe 'ReferralUsers' do
  let!(:referral_code) { create(:referral_code, :with_onboarding_group) }
  let(:onboarding_group) { referral_code.onboarding_group }

  describe 'POST /api/v1/referrals' do
    def do_request(params={})
      post "/api/v1/referrals/", params
    end

    let(:email) { 'new_test@test.getbetter.com' }
    let(:user_attributes) { {email: email, code: referral_code.code} }

    it 'creates a user for the onboarding group' do
      expect{ do_request(user_attributes) }.to change(Member, :count).by(1)
      expect(response).to be_success
      new_user = Member.find_by_email!(email)
      expect(new_user.onboarding_group).to eq(onboarding_group)
      expect(new_user.invitation_token).to_not be_nil
    end
  end
end

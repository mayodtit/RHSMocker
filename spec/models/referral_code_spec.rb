require 'spec_helper'

describe ReferralCode do
  it_has_a 'valid factory'
  it_has_a 'valid factory', :with_onboarding_group

  describe 'validations' do
    before do
      described_class.any_instance.stub(:set_code)
    end

    it_validates 'presence of', :code
    it_validates 'uniqueness of', :code
    it_validates 'foreign key of', :user
    it_validates 'foreign key of', :creator
    it_validates 'foreign key of', :onboarding_group
  end

  describe 'callbacks' do
    describe '#set_code' do
      it 'automatically sets the code on create' do
        referral_code = build(:referral_code, code: nil)
        expect(referral_code.code).to be_nil
        referral_code.save!
        expect(referral_code.code).to_not be_nil
      end

      it 'does not set the same code twice' do
        referral_code = create(:referral_code)
        new_referral_code = build(:referral_code, code: nil)
        new_referral_code.stub(:base32_code).and_return(referral_code.code, 'NEWCODE')
        expect(new_referral_code.code).to be_nil
        new_referral_code.save!
        expect(new_referral_code.code).to eq('NEWCODE')
      end
    end
  end
end

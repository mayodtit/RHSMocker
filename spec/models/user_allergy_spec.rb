require 'spec_helper'

describe UserAllergy do
  let(:user_allergy) { build(:user_allergy) }

  describe 'factory' do
    it 'creates a valid object' do
      user_allergy.should be_valid
      user_allergy.save.should be_true
      user_allergy.should be_persisted
    end
  end

  describe 'validations' do
    it 'requires a user' do
      build(:user_allergy, :user => nil).should_not be_valid
    end

    it 'requires an allergy' do
      build(:user_allergy, :allergy => nil).should_not be_valid
    end

    it 'allows only unique allergies for a user' do
      ua = create(:user_allergy)
      ua2 = build(:user_allergy, :user => ua.user, :allergy => ua.allergy)
      ua2.should_not be_valid
      ua2.should have(1).error_on(:allergy_id)
    end
  end
end

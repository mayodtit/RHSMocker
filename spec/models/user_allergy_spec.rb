require 'spec_helper'

describe UserAllergy do
  it_has_a 'valid factory'
  it_validates 'presence of', :user
  it_validates 'presence of', :allergy

  it 'allows only unique allergies for a user' do
    ua = create(:user_allergy)
    ua2 = build(:user_allergy, :user => ua.user, :allergy => ua.allergy)
    ua2.should_not be_valid
    ua2.should have(1).error_on(:allergy_id)
  end
end

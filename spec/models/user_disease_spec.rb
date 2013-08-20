require 'spec_helper'

describe UserDisease do
  it_has_a 'valid factory'

  it_validates 'presence of', :user
  it_validates 'presence of', :disease

  describe 'diagnosed' do
    let(:diagnosed_user_disease) { build_stubbed(:user_disease, :diagnosed) }

    describe 'factory trait' do
      it 'creates valid objects' do
        diagnosed_user_disease.should be_valid
      end

      it 'creates diagnosed objects' do
        diagnosed_user_disease.diagnosed.should be_true
      end
    end
  end

  describe '#user_treatment_ids=' do
    let(:user) { create(:member) }
    let(:user_disease) { create(:user_disease, :user => user) }
    let(:user_treatment) { create(:user_treatment, :user => user) }

    it 'links the user_treatment to the user_disease' do
      user_disease.user_treatments.should_not include(user_treatment)
      user_disease.update_attributes(user_treatment_ids: [user_treatment.id]).should be_true
      user_disease.reload.user_treatments.should include(user_treatment)
    end

    it 'deletes user_treatments removed from the list' do
      user_disease.user_treatments << user_treatment
      user_disease.user_treatments.should include(user_treatment)
      user_disease.update_attributes(user_treatment_ids: []).should be_true
      user_disease.reload.user_treatments.should_not include(user_treatment)
    end
  end
end

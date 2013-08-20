require 'spec_helper'

describe UserCondition do
  it_has_a 'valid factory'

  it_validates 'presence of', :user
  it_validates 'presence of', :disease

  describe 'diagnosed' do
    let(:diagnosed_user_condition) { build_stubbed(:user_condition, :diagnosed) }

    describe 'factory trait' do
      it 'creates valid objects' do
        diagnosed_user_condition.should be_valid
      end

      it 'creates diagnosed objects' do
        diagnosed_user_condition.diagnosed.should be_true
      end
    end
  end

  describe '#user_treatment_ids=' do
    let(:user) { create(:member) }
    let(:user_condition) { create(:user_condition, :user => user) }
    let(:user_treatment) { create(:user_treatment, :user => user) }

    it 'links the user_treatment to the user_condition' do
      user_condition.user_treatments.should_not include(user_treatment)
      user_condition.update_attributes(user_treatment_ids: [user_treatment.id]).should be_true
      user_condition.reload.user_treatments.should include(user_treatment)
    end

    it 'deletes user_treatments removed from the list' do
      user_condition.user_treatments << user_treatment
      user_condition.user_treatments.should include(user_treatment)
      user_condition.update_attributes(user_treatment_ids: []).should be_true
      user_condition.reload.user_treatments.should_not include(user_treatment)
    end
  end
end

require 'spec_helper'

describe UserTreatment do
  it_has_a 'valid factory'

  it_validates 'presence of', :user
  it_validates 'presence of', :treatment

  describe '#user_condition_ids=' do
    let(:user) { create(:member) }
    let(:user_condition) { create(:user_condition, :user => user) }
    let(:user_treatment) { create(:user_treatment, :user => user) }

    it 'links the user_condition to the user_treatment' do
      user_treatment.user_conditions.should_not include(user_condition)
      user_treatment.update_attributes(user_condition_ids: [user_condition.id]).should be_true
      user_treatment.reload.user_conditions.should include(user_condition)
    end

    it 'deletes user_condition removed from the list' do
      user_treatment.user_conditions << user_condition
      user_treatment.user_conditions.should include(user_condition)
      user_treatment.update_attributes(user_condition_ids: []).should be_true
      user_treatment.reload.user_conditions.should_not include(user_condition)
    end
  end
end

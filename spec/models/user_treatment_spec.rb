require 'spec_helper'

describe UserTreatment do
  it_has_a 'valid factory'

  it_validates 'presence of', :user
  it_validates 'presence of', :treatment

  describe '#user_disease_ids=' do
    let(:user) { create(:member) }
    let(:user_disease) { create(:user_disease, :user => user) }
    let(:user_treatment) { create(:user_treatment, :user => user) }

    it 'links the user_disease to the user_treatment' do
      user_treatment.user_diseases.should_not include(user_disease)
      user_treatment.update_attributes(user_disease_ids: [user_disease.id]).should be_true
      user_treatment.reload.user_diseases.should include(user_disease)
    end

    it 'deletes user_disease removed from the list' do
      user_treatment.user_diseases << user_disease
      user_treatment.user_diseases.should include(user_disease)
      user_treatment.update_attributes(user_disease_ids: []).should be_true
      user_treatment.reload.user_diseases.should_not include(user_disease)
    end
  end
end

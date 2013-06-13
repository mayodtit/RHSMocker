require 'spec_helper'

describe UserDiseaseTreatmentTreatmentSideEffect do
  let(:udttse) { build(:user_disease_treatment_treatment_side_effect) }

  describe 'factory' do
    it 'creates a valid object' do
      udttse.should be_valid
      udttse.save.should be_true
      udttse.should be_persisted
    end
  end

  describe 'validations' do
    it 'requires UserDiseaseTreatment' do
      udttse.should be_valid
      udttse.user_disease_treatment = nil
      udttse.should_not be_valid
    end

    it 'requires TreatmentSideEffect' do
      udttse.should be_valid
      udttse.treatment_side_effect = nil
      udttse.should_not be_valid
    end
  end
end

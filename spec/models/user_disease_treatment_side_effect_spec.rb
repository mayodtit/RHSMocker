require 'spec_helper'

describe UserDiseaseTreatmentSideEffect do
  let(:udtse) { build(:user_disease_treatment_side_effect) }

  describe 'factory' do
    it 'creates a valid object' do
      udtse.should be_valid
      udtse.save.should be_true
      udtse.should be_persisted
    end
  end

  describe 'validations' do
    it 'requires a user_disease_treatment' do
      udtse.should be_valid
      udtse.user_disease_treatment = nil
      udtse.should_not be_valid
    end

    it 'requires a side_effect' do
      udtse.should be_valid
      udtse.side_effect = nil
      udtse.should_not be_valid
    end
  end
end

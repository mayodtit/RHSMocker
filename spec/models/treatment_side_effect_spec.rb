require 'spec_helper'

describe TreatmentSideEffect do
  let(:treatment_side_effect) { build(:treatment_side_effect) }

  describe 'factory' do
    it 'creates a valid object' do
      treatment_side_effect.should be_valid
      treatment_side_effect.save.should be_true
      treatment_side_effect.should be_persisted
    end
  end

  describe 'validations' do
    it 'requires a treatment' do
      treatment_side_effect.should be_valid
      treatment_side_effect.treatment = nil
      treatment_side_effect.should_not be_valid
    end

    it 'requires a side_effect' do
      treatment_side_effect.should be_valid
      treatment_side_effect.side_effect = nil
      treatment_side_effect.should_not be_valid
    end
  end
end

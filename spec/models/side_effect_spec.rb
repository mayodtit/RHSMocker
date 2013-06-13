require 'spec_helper'

describe SideEffect do
  let(:side_effect) { build(:side_effect) }

  describe 'factory' do
    it 'creates valid objects' do
      side_effect.should be_valid
      side_effect.save.should be_true
      side_effect.should be_persisted
    end
  end

  describe 'validations' do
    it 'requires a name' do
      side_effect.should be_valid
      side_effect.name = nil
      side_effect.should_not be_valid
    end
  end

  describe '::for_treatment' do
    let!(:treatment) { create(:treatment) }
    let!(:side_effect) { create(:side_effect) }
    let!(:treatment_side_effect) { create(:treatment_side_effect,
                                          :treatment => treatment,
                                          :side_effect => side_effect) }
    let!(:excluded_side_effect) { create(:side_effect, :with_treatment) }

    before(:each) do
      described_class.all.should include(side_effect, excluded_side_effect)
    end

    it 'returns a relation of Treatments scoped by the Treatment' do
      described_class.for_treatment(treatment).should include(side_effect)
      described_class.for_treatment(treatment).should_not include(excluded_side_effect)
    end

    it 'accept id as an argument successfully' do
      described_class.for_treatment(treatment.id).should include(side_effect)
      described_class.for_treatment(treatment.id).should_not include(excluded_side_effect)
    end
  end
end

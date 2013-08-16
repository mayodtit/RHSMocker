require 'spec_helper'

describe SideEffect do
  it_has_a 'valid factory'
  it_validates 'presence of', :name

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

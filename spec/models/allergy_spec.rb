require 'spec_helper'

describe Allergy do
  it_has_a 'valid factory'
  it_behaves_like 'model with SOLR index'

  describe '::names_with_duplicates' do
    let!(:allergy) { create(:allergy, name: 'Duplicate') }
    let!(:duplicate) { create(:allergy, name: 'Duplicate') }
    let!(:not_duplicate) { create(:allergy) }

    it 'returns an array of Allergy names that have duplicates' do
      expect(described_class.names_with_duplicates).to eq([allergy.name])
    end
  end

  describe '::deduplicate_names!' do
    let!(:allergy) { create(:allergy, name: 'Duplicate') }
    let(:number_of_duplicates) { 3 }
    let!(:allergy_duplicates) { create_list(:allergy, number_of_duplicates, name: 'Duplicate') }

    context 'with UserAllergies' do
      before do
        allergy_duplicates.each do |duplicate|
          create(:user_allergy, allergy: duplicate)
        end
      end

      it 'assigns UserAllergies referencing duplicates to the single Allergy' do
        expect(allergy.user_allergies.count).to be_zero
        described_class.deduplicate_names!
        expect(allergy.user_allergies.count).to eq(number_of_duplicates)
      end
    end

    it 'deletes duplicates' do
      expect(described_class.where(id: allergy_duplicates.map(&:id))).to_not be_empty
      described_class.deduplicate_names!
      expect(described_class.where(id: allergy_duplicates.map(&:id))).to be_empty
    end
  end
end

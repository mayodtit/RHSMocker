require 'spec_helper'

describe Allergy do
  it_has_a 'valid factory'
  it_behaves_like 'model with SOLR index'
  it_validates 'foreign key of', :master_synonym

  describe '::names_with_duplicates' do
    let!(:allergy) { create(:allergy, name: 'Duplicate') }
    let!(:duplicate) { create(:allergy, name: 'Duplicate') }
    let!(:not_duplicate) { create(:allergy) }

    it 'returns an array of Allergy names that have duplicates' do
      expect(described_class.names_with_duplicates).to eq([allergy.name])
    end
  end

  describe '::identify_synonyms!' do
    let!(:allergy) { create(:allergy, name: 'Duplicate') }
    let(:number_of_duplicates) { 3 }
    let!(:allergy_duplicates) { create_list(:allergy, number_of_duplicates, name: 'Duplicate') }

    it 'sets master_synonym_id on duplicates' do
      described_class.identify_synonyms!
      expect(allergy.reload.master_synonym).to be_nil
      allergy_duplicates.each do |a|
        expect(a.reload.master_synonym).to eq(allergy)
      end
    end

    context 'with UserAllergies' do
      before do
        allergy_duplicates.each do |duplicate|
          create(:user_allergy, allergy: duplicate)
        end
      end

      it 'assigns UserAllergies referencing duplicates to the single Allergy' do
        expect(allergy.user_allergies.count).to be_zero
        described_class.identify_synonyms!
        expect(allergy.user_allergies.count).to eq(number_of_duplicates)
      end
    end
  end
end

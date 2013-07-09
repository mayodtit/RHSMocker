require 'spec_helper'

describe AssociationType do
  describe 'factory' do
    let(:association_type) { build(:association_type) }

    it 'builds a valid object' do
      association_type.should be_valid
      association_type.save.should be_true
      association_type.should be_persisted
    end
  end

  describe 'validations' do
    it 'requires a name' do
      build_stubbed(:association_type, name: nil).should_not be_valid
    end

    it 'requires a gender' do
      build_stubbed(:association_type, gender: nil).should_not be_valid
    end

    it 'requires a relationship_type' do
      build_stubbed(:association_type, relationship_type: nil).should_not be_valid
    end
  end
end

require 'spec_helper'

describe Treatment::LifestyleChange do
  let(:treatment) { build(:lifestyle_change_treatment) }

  describe 'factory' do
    it 'builds the right object' do
      treatment.should be_instance_of(Treatment::LifestyleChange)
    end

    it 'builds a valid object' do
      treatment.should be_valid
      treatment.save.should be_true
      treatment.should be_persisted
    end
  end

  describe '#type_name' do
    it 'returns the correct type string' do
      treatment.type_name.should == 'lifestyle_change'
    end
  end
end

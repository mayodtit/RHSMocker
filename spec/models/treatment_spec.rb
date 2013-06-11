require 'spec_helper'

describe Treatment do
  let(:treatment) { build(:treatment) }

  describe 'factory' do
    it 'creates a valid object' do
      treatment.should be_valid
      treatment.save.should be_true
      treatment.should be_persisted
    end
  end

  describe '#type_name' do
    it 'returns the type as a string' do
      treatment.type_name.should == 'treatment'
    end

    it "returns 'treatment' when nil" do
      treatment.type = nil
      treatment.type_name.should == 'treatment'
    end
  end
end

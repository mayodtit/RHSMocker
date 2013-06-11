require 'spec_helper'

describe Treatment::Surgery do
  let(:treatment) { build(:surgery_treatment) }

  describe 'factory' do
    it 'builds the right object' do
      treatment.should be_instance_of(Treatment::Surgery)
    end

    it 'builds a valid object' do
      treatment.should be_valid
      treatment.save.should be_true
      treatment.should be_persisted
    end
  end

  describe '#type_name' do
    it 'returns the correct type string' do
      treatment.type_name.should == 'surgery'
    end
  end
end

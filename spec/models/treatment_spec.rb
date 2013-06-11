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

  describe '#as_json' do
    let(:treatment) { create(:medicine_treatment) }

    it 'returns a hash of model attributes' do
      json = treatment.as_json
      json[:id].should == treatment.id
      json[:type].should == treatment.type_name
      json[:name].should == treatment.name
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

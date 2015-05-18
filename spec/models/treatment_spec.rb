require 'spec_helper'

describe Treatment do
  it_has_a 'valid factory'
  it_behaves_like 'model with SOLR index'
  it_validates 'presence of', :type

  it 'defaults to Treatment::Medicine type' do
    build_stubbed(:treatment).should be_instance_of(Treatment::Medicine)
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
      build_stubbed(:treatment).type_name.should == 'medicine'
    end
  end
end

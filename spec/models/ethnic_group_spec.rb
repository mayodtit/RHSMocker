require 'spec_helper'

describe EthnicGroup do
  it_has_a 'valid factory'
  it_validates 'presence of', :name

  context 'without callbacks' do
    before(:each) do
      described_class.any_instance.stub(:set_ordinal)
      described_class.any_instance.stub(:set_ethnicity_code)
    end

    it_validates 'presence of', :ordinal
    it_validates 'presence of', :ethnicity_code
  end

  describe 'callbacks' do
    it 'sets the ordinal before validation' do
      ethnic_group = build_stubbed(:ethnic_group, :ordinal => nil)
      ethnic_group.ordinal.should be_nil
      ethnic_group.valid?
      ethnic_group.ordinal.should_not be_nil
    end

    it 'sets the ordinal if the ordinal is 0 (default)' do
      ethnic_group = build_stubbed(:ethnic_group, :ordinal => 0)
      ethnic_group.ordinal.should be_zero
      ethnic_group.valid?
      ethnic_group.ordinal.should_not be_zero
    end

    it 'sets the ethnicity_code before validation' do
      ethnic_group = build_stubbed(:ethnic_group, :ethnicity_code => nil)
      ethnic_group.ethnicity_code.should be_nil
      ethnic_group.valid?
      ethnic_group.ethnicity_code.should_not be_nil
    end

    it 'sets the ethnicity_code if the ethnicity_code is 0 (default)' do
      ethnic_group = build_stubbed(:ethnic_group, :ethnicity_code => 0)
      ethnic_group.ethnicity_code.should be_zero
      ethnic_group.valid?
      ethnic_group.ethnicity_code.should_not be_zero
    end
  end
end

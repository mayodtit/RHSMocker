require 'spec_helper'

describe Diet do
  it_has_a 'valid factory'
  it_validates 'presence of', :name

  context 'without callbacks' do
    before(:each) do
      Diet.any_instance.stub(:set_ordinal)
    end

    it_validates 'presence of', :ordinal
  end

  it_validates 'uniqueness of', :ordinal

  describe 'callbacks' do
    it 'sets the ordinal before validation' do
      diet = build_stubbed(:diet, :ordinal => nil)
      diet.ordinal.should be_nil
      diet.valid?
      diet.ordinal.should_not be_nil
    end

    it 'sets the ordinal if the ordinal is 0 (default)' do
      diet = build_stubbed(:diet, :ordinal => 0)
      diet.ordinal.should be_zero
      diet.valid?
      diet.ordinal.should_not be_zero
    end
  end
end

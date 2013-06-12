require 'spec_helper'

describe SideEffect do
  let(:side_effect) { build(:side_effect) }

  describe 'factory' do
    it 'creates valid objects' do
      side_effect.should be_valid
      side_effect.save.should be_true
      side_effect.should be_persisted
    end
  end

  describe 'validations' do
    it 'requires a name' do
      side_effect.should be_valid
      side_effect.name = nil
      side_effect.should_not be_valid
    end
  end
end

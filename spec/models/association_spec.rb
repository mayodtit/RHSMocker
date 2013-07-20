require 'spec_helper'

describe Association do
  describe 'factory' do
    let(:association) { build(:association) }

    it 'creates a valid object' do
      association.should be_valid
      association.save.should be_true
      association.should be_persisted
    end
  end

  describe 'validations' do
    it 'requires a user' do
      build_stubbed(:association, user: nil).should_not be_valid
    end

    it 'requires a associate' do
      build_stubbed(:association, associate: nil).should_not be_valid
    end

    it 'requires a association_type' do
      build_stubbed(:association, association_type: nil).should_not be_valid
    end

    it 'requires the user is not the associate' do
      user = build_stubbed(:user)
      build_stubbed(:association, user: user, associate: user).should_not be_valid
    end
  end
end

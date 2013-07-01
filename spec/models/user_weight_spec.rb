require 'spec_helper'

describe UserWeight do
  let(:weight) { build(:user_weight) }

  describe 'factory' do
    it 'builds a valid object' do
      weight.should be_valid
      weight.save.should be_true
      weight.should be_persisted
    end
  end

  describe 'validations' do
    it 'requires a user' do
      build(:user_weight, :user => nil).should_not be_valid
    end

    it 'requires a weight' do
      build(:user_weight, :weight => nil).should_not be_valid
    end

    it 'requires a taken_at' do
      build(:user_weight, :taken_at => nil).should_not be_valid
    end
  end

  describe 'callbacks' do
    let(:height) { 180 }

    before(:each) do
      weight.bmi = nil
      weight.user.height = height
    end

    it 'sets bmi before validation' do
      weight.bmi.should be_nil
      weight.valid?
      weight.bmi.should_not be_nil
    end

    it 'sets the correct value for bmi' do
      weight.valid? # to trigger callback
      weight.bmi.should == (weight.weight / ((height * 0.01) * (height * 0.01)))
    end
  end
end

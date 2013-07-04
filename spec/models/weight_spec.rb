require 'spec_helper'

describe Weight do
  let(:weight) { build_stubbed(:weight) }

  describe 'factory' do
    let(:weight) { build(:weight) }

    it 'builds a valid object' do
      weight.should be_valid
      weight.save.should be_true
      weight.should be_persisted
    end
  end

  describe 'validations' do
    it 'requires a user' do
      build_stubbed(:weight, :user => nil).should_not be_valid
    end

    it 'requires an amount' do
      build_stubbed(:weight, :amount => nil).should_not be_valid
    end

    it 'requires a taken_at' do
      build_stubbed(:weight, :taken_at => nil).should_not be_valid
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
      weight.bmi.should == (weight.amount / ((height * 0.01) * (height * 0.01)))
    end
  end

  describe '::most_recent_for' do
    let!(:weight) { create(:weight) }
    let!(:other_weight) { create(:weight,
                                 :user => weight.user,
                                 :taken_at => weight.taken_at - 1.day) }
    let(:user) { weight.user }

    it 'returns the most recent weight for a given user' do
      described_class.most_recent_for(user).should == weight
    end

    it 'returns the most recent weight for the correct user' do
      create(:weight, :taken_at => weight.taken_at + 1.day)
      described_class.most_recent_for(user).should == weight
    end

    it 'accepts user or user_id as argument' do
      described_class.most_recent_for(user).should == weight
      described_class.most_recent_for(user.id).should == weight
    end
  end
end

require 'spec_helper'

describe UserWeight do
  let(:weight) { build(:user_weight) }

  # TODO - this is a hack to eliminate false positives resulting from dirty database
  before(:each) do
    User.delete_all
  end

  it_has_a 'valid factory'
  it_validates 'presence of', :user
  it_validates 'presence of', :weight
  it_validates 'presence of', :taken_at

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

  describe '::most_recent_for_user' do
    let!(:user_weight) { create(:user_weight) }
    let!(:other_user_weight) { create(:user_weight,
                                      :user => user_weight.user,
                                      :taken_at => user_weight.taken_at - 1.day) }
    let(:user) { user_weight.user }

    it 'returns the most recent weight for a given user' do
      described_class.most_recent_for_user(user).should == user_weight
    end

    it 'returns the most recent weight for the correct user' do
      create(:user_weight, :taken_at => user_weight.taken_at + 1.day)
      described_class.most_recent_for_user(user).should == user_weight
    end

    it 'accepts user or user_id as argument' do
      described_class.most_recent_for_user(user).should == user_weight
      described_class.most_recent_for_user(user.id).should == user_weight
    end
  end
end

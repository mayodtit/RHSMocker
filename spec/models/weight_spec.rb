require 'spec_helper'

describe Weight do
  it_has_a 'valid factory'

  it_validates 'presence of', :user
  it_validates 'presence of', :amount
  it_validates 'presence of', :taken_at

  describe 'callbacks' do
    let(:weight) { build_stubbed(:weight) }
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

  describe '::most_recent' do
    let!(:weight) { create(:weight) }
    let!(:other_weight) { create(:weight,
                                 :user => weight.user,
                                 :taken_at => weight.taken_at - 1.day) }

    it 'returns the most recent weight for a given user' do
      described_class.most_recent.should == weight
    end
  end
end

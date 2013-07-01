require 'spec_helper'

describe BloodPressure do
  let(:blood_pressure) { build(:blood_pressure) }

  describe 'factory' do
    it 'creates a valid object' do
      blood_pressure.should be_valid
      blood_pressure.save.should be_true
      blood_pressure.should be_persisted
    end
  end

  describe 'validations' do
    it 'requires a user' do
      build(:blood_pressure, :user => nil).should_not be_valid
    end

    it 'requires a collection_type' do
      build(:blood_pressure, :collection_type => nil).should_not be_valid
    end

    it 'requires a diastolic' do
      build(:blood_pressure, :diastolic => nil).should_not be_valid
    end

    it 'requires a systolic' do
      build(:blood_pressure, :systolic => nil).should_not be_valid
    end

    it 'requires a taken_at' do
      build(:blood_pressure, :taken_at => nil).should_not be_valid
    end
  end

  describe '::most_recent_for_user' do
    let!(:blood_pressure) { create(:blood_pressure) }
    let!(:other_blood_pressure) { create(:blood_pressure,
                                         :user => blood_pressure.user,
                                         :taken_at => blood_pressure.taken_at - 1.day) }
    let(:user) { blood_pressure.user }

    it 'returns the most recent blood pressure for a given user' do
      described_class.most_recent_for_user(user).should == blood_pressure
    end

    it 'returns the most recent blood pressure for the correct user' do
      create(:blood_pressure, :taken_at => blood_pressure.taken_at + 1.day)
      described_class.most_recent_for_user(user).should == blood_pressure
    end

    it 'accepts user or user_id as argument' do
      described_class.most_recent_for_user(user).should == blood_pressure
      described_class.most_recent_for_user(user.id).should == blood_pressure
    end
  end
end

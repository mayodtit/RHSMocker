require 'spec_helper'

describe BloodPressure do
  let(:blood_pressure) { build(:blood_pressure) }

  it_has_a 'valid factory'
  it_validates 'presence of', :user
  it_validates 'presence of', :collection_type
  it_validates 'presence of', :diastolic
  it_validates 'presence of', :systolic
  it_validates 'presence of', :taken_at

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

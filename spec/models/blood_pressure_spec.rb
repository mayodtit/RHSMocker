require 'spec_helper'

describe BloodPressure do
  it_has_a 'valid factory'

  describe 'validations' do
    # stub collection_type setter to test validation
    before(:each) do
      described_class.any_instance.stub(:set_collection_type)
    end

    it_validates 'presence of', :user
    it_validates 'presence of', :collection_type
    it_validates 'presence of', :diastolic
    it_validates 'presence of', :systolic
    it_validates 'presence of', :taken_at
  end

  describe '::most_recent' do
    let!(:blood_pressure) { create(:blood_pressure) }
    let!(:other_blood_pressure) { create(:blood_pressure,
                                         :user => blood_pressure.user,
                                         :taken_at => blood_pressure.taken_at - 1.day) }

    it 'returns the most recent blood pressure' do
      described_class.most_recent.should == blood_pressure
    end
  end
end

require 'spec_helper'

describe UserReading do
  describe 'factory' do
    it 'builds a valid object' do
      build(:user_reading).should be_valid
    end
  end

  describe "validations" do
    it "should raise an error if either user or content is nil" do
      u = FactoryGirl.create :user
      c = FactoryGirl.create :content

      expect{UserReading.create!(user: u)}.to raise_error(Exception)
      expect{UserReading.create!(content: c)}.to raise_error(Exception)

      expect{UserReading.create!(content: c, user: u)}.to_not raise_error(Exception)
    end
  end
end
